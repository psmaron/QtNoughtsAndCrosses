#include "GameBoard.h"

#include <iostream>

GameBoard::GameBoard()
{
    for (auto& square : board)
        square = Symbol::None;
}

/*!
 * \brief GameBoard::initBoard
 *
 * Should be invoked after all of the UI components are ready
 * Sends them some initialization data
 */
void GameBoard::initBoard() {
    emit nextTurnForPlayer(getCurrentPlayer().id);

    QStringList playersData; // continuous array of both players data
    playersData.append("O"); // symbol
    playersData.append("0"); // wins
    playersData.append("0"); // loses
    playersData.append("0"); // draws
    playersData.append("X"); // etc for 2nd player ...
    playersData.append("0");
    playersData.append("0");
    playersData.append("0");

    emit updateStats(playersData);
}

/*!
 * \brief GameBoard::squarePressed
 * \param squareIndex
 *
 * If user did press a square, check if game should be continued.
 * If not, then either someone has won or it's a draw
 * Otherwise, put symbol and continue
 */
void GameBoard::squarePressed(int squareIndex)
{
    if (board[squareIndex] == Symbol::None) {
        putSymbolOnSquare(squareIndex);
        if (hasPlayerWon()) {
            endGame();
        }
        else {
            if (isDraw()) {
                handleDraw();
                return;
            }
            turnsCounter++;
            emit nextTurnForPlayer(getCurrentPlayer().id);
        }
    }
}

void GameBoard::putSymbolOnSquare(int squareIndex) {
    board[squareIndex] = getCurrentPlayer().symbol;
    emit putSymbol(squareIndex, getCurrentPlayer().symbol == Symbol::Circle ? "o" : "x");
}

bool GameBoard::hasPlayerWon() {
    return getWinType() != WinType::None;
}

void GameBoard::endGame() {
    emit markWinningLine(getWinType());
    emit endGameWithMessage("Player " + getCurrentPlayer().id + " has won!");
    restartGame(getCurrentPlayer().symbol);
}

bool GameBoard::isDraw() {
    return turnsCounter+1 == 9;
}

void GameBoard::handleDraw() {
    emit endGameWithMessage("It's a draw!");
    restartGame(Symbol::None);
}

/*!
 * \brief GameBoard::getWinType
 * \return
 *
 * Just checks every combination for a win pattern and returns it's type
 */
GameBoard::WinType GameBoard::getWinType() {
    // Game board indexes:
    // 0 1 2
    // 3 4 5
    // 6 7 8
    if (board[0] != Symbol::None && board[0] == board[1] && board[1] == board[2])
        return WinType::FirstRow;
    if (board[3] != Symbol::None && board[3] == board[4] && board[4] == board[5])
        return WinType::SecondRow;
    if (board[6] != Symbol::None && board[6] == board[7] && board[7] == board[8])
        return WinType::ThirdRow;
    if (board[0] != Symbol::None && board[0] == board[3] && board[3] == board[6])
        return WinType::FirstColumn;
    if (board[1] != Symbol::None && board[1] == board[4] && board[4] == board[7])
        return WinType::SecondColumn;
    if (board[2] != Symbol::None && board[2] == board[5] && board[5] == board[8])
        return WinType::ThirdColumn;
    if (board[0] != Symbol::None && board[0] == board[4] && board[4] == board[8])
        return WinType::FirstDiagonal;
    if (board[6] != Symbol::None && board[6] == board[4] && board[4] == board[2])
        return WinType::SecondDiagonal;

    return WinType::None;
}

GameBoard::Player GameBoard::getCurrentPlayer() {
    if (player1.starts) {
        if (turnsCounter % 2 == 0)
            return player1;
        else
            return player2;
    }
    else {
        if (turnsCounter % 2 == 0)
            return player2;
        else
            return player1;
    }
}

void GameBoard::restartGame(Symbol winner) {
    // recalculate players statistics
    if (winner == Symbol::None) {
        player1.draws++;
        player2.draws++;
    }
    else {
        if (player1.symbol == winner) {
            player1.wins++;
            player2.loses++;
        }
        else {
            player2.wins++;
            player1.loses++;
        }
    }
    // switch who starts next game
    player1.starts = !player1.starts;
    player2.starts = !player2.starts;
    player1.symbol = player1.starts ? Symbol::Circle : Symbol::Cross;
    player2.symbol = player2.starts ? Symbol::Circle : Symbol::Cross;
    emit nextTurnForPlayer(getCurrentPlayer().id);

    // send updated data to be displayed
    QStringList playersData;
    playersData.append(player1.starts ? "O" : "X");
    playersData.append(QString::number(player1.wins));
    playersData.append(QString::number(player1.loses));
    playersData.append(QString::number(player1.draws));
    playersData.append(player2.starts ? "O" : "X");
    playersData.append(QString::number(player2.wins));
    playersData.append(QString::number(player2.loses));
    playersData.append(QString::number(player2.draws));
    emit updateStats(playersData);


    // reset board
    turnsCounter = 0;
    for (auto& square : board)
        square = Symbol::None;

    emit clearBoard();
}
