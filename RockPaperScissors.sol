// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

contract RockPaperScissors {
  
  event GameCreated(address creator, uint gameNumber, uint bet);
  event GameStarted(address[2] players, uint gameNumber);
  event GameComplete(address winner, uint gameNumber);

  uint gameNumberVar = 0;
  address owner;

  constructor(){
      owner = msg.sender; 
  }

  struct Game {
      
      address creator;
      address participant;
      address winner;
      
      uint    betCreator;
      uint    betParicipant;

      uint16  movementC;
      uint16  movementP;

      bool    finish;
      bool    started;
      
  }

  mapping(uint => Game) games;

  function createGame(address payable participant) public payable {
    
    require(msg.value > 0);
    
    gameNumberVar++;
    Game memory game = Game(msg.sender, participant, address(0), msg.value, 0, 0, 0, false, false);
    games[gameNumberVar] = game;
    
    payable(owner).transfer(msg.value);

    emit GameCreated(msg.sender, gameNumberVar, msg.value);
  
  }
  
  function joinGame(uint gameNumber) public payable {
      
      require(gameNumber <= gameNumberVar);
      
      Game storage game = games[gameNumber];
      require(!game.started);
      require(game.participant == msg.sender);
      require(game.betCreator <= msg.value);
      
      uint val = msg.value;
      
      if(val > game.betCreator){
          uint rettn = val - game.betCreator;
          payable(msg.sender).transfer(rettn);
          val = game.betCreator;
      }

      game.betParicipant = val;
      payable(owner).transfer(val);
      game.started = true;
      address[2] memory players = [game.creator, game.participant];

      emit GameStarted(players, gameNumber);

  }
  

  function makeMove(uint gameNumber, uint16 moveNumber) public { 

    require(moveNumber > 0 && moveNumber < 4);
    require(gameNumber <= gameNumberVar);
    
    Game storage game = games[gameNumber];
    require(game.participant == msg.sender || game.creator == msg.sender);
    
    if(msg.sender == game.participant){
        require(game.movementP == 0);
        game.movementP = moveNumber;
    }

    if(msg.sender == game.creator){
        require(game.movementC == 0);
        game.movementC = moveNumber;
    }

    if(game.movementC > 0 && game.movementP > 0){
        // logica do jogo
        if(game.movementC != game.movementP){
            game.finish = true;
            if(
            (game.movementC == 1 && game.movementP == 3) || 
            (game.movementC == 2 && game.movementP == 1) || 
            (game.movementC == 3 && game.movementP == 2)) {
                // creator win
                game.winner = game.creator;
            } else {
                // participant win
                game.winner = game.participant;
            }
        }
        
        emit GameComplete(game.winner, gameNumber);

        winner(gameNumber);

    }

  }

  function winner(uint gameNumber) internal {
      
      Game memory game = games[gameNumber];
      
      if(!game.finish){
          payable(game.creator).transfer(game.betCreator);
          payable(game.participant).transfer(game.betParicipant);
      } else {
          uint value = game.betCreator + game.betParicipant;
          payable(game.winner).transfer(value);
      }
      
      emit GameComplete(game.winner, gameNumber);
  } 

}