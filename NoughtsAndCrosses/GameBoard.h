#ifndef GAMEBOARD_H
#define GAMEBOARD_H

#include <QQuickItem>
#include <QList>
#include <QMap>
#include <QString>

class GameBoard : public QQuickItem
{
    Q_OBJECT

public:
    GameBoard();

    Q_INVOKABLE void squarePressed(int squareIndex);
    Q_INVOKABLE void initBoard();

signals:
    void putSymbol(int squareIndex, QString mark);
    void endGameWithMessage(QString message);
    void clearBoard();
    void nextTurnForPlayer(QString playerId);
    void updateStats(QStringList playersData);
    void markWinningLine(int winType);

private:
    enum class Symbol {
        None,
        Cross,
        Circle
    };

    enum WinType {
        None,
        FirstRow, SecondRow, ThirdRow,
        FirstColumn, SecondColumn, ThirdColumn,
        FirstDiagonal, SecondDiagonal
    };

    struct Player {     // players data are stored here and after serialization are sent to the frontend
        Symbol symbol;  // should use MVC instead, but whole app code is already huge, so I took some shortcuts
        QString id;
        int wins;
        int loses;
        int draws;
        bool starts;
    };

    void putSymbolOnSquare(int squareIndex);
    WinType getWinType();
    bool hasPlayerWon();
    void endGame();
    bool isDraw();
    void handleDraw();
    Player getCurrentPlayer();
    void restartGame(Symbol winner);

    Player player1{Symbol::Circle, "1", 0, 0, 0, true};
    Player player2{Symbol::Cross, "2", 0, 0, 0, false};

    unsigned long turnsCounter = 0;
    Symbol board[9]; // yes, 9 is hardcoded!
};

#endif // GAMEBOARD_H
