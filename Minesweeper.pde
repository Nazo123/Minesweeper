import java.util.List;
import java.util.ArrayList;

// Game settings
int cellWidth = 40;            // in pixels
int headerHeight = cellWidth;  // height of game info header
int numOfMines = 10;           // number of mines in the game
int minesFlagged = 0;          // number of mines flagged
color cellColor = #C0C0C0;     // color of unrevealed cell

// Game images
PImage empty, one, two, three, four, five, six, seven, eight;
PImage mineImg, pinImg, wonImg, lostImg;
PImage[] images;

// Game variables
int rows;                     // same number of columns as rows
Button startButton;
List<Cell> cells = new ArrayList<Cell>();
boolean gameReady = false;
boolean gameInProgress = false;
int nowMs, gameTimeSec;

/*
 * *** START HERE ***
 * First steps are to create the program window, cells, and mines
 */
void setup() {
  // 1. Use size(width, height) to set the width and height of the window
  size(400, 440);
  
  // 2. Use the initializeGameData() function to set up the game header
  initializeGameData();
  
  // 3. Use the initializeCells() function to set up the playing grid cells
  initializeCells();
  
  // 4. Use the initializeMines() function to randomly place the mines
  initializeMines();
}

/*
 * Draw all game objects
 */
void draw() {
  // 5. Use an 'if' statement to check if game_read is set to true
  if( gameReady ){
    
    // 6. Use background(color) to set the game's background
    // Do you see your color when you run the code?
    background(255);
    
    // 7. Use the drawGameHeader() function to draw the game's header
    // Skip down and complete the draw_game_header() function
    drawGameHeader();
    
    // 11. Complete the instructions in drawGameHeader() FIRST!
    // Use the drawCells() function to draw the game's grid cells
    //Skip down and complete the draw_cells() function
    drawCells();
    
    // 14. Use the updateGameTime() function to count the game seconds
    // when the game starts.
    // Does the game start counting up the seconds when the start button is pressed?
    updateGameTime();
    
    // *** ENHANCEMENTS ***
    // * Changing the game background color?
    // * Can you figure out how to change the color of each cell?
    // * Adding difficulty modes that change the game's window size
    //   and number of mines.
    // * Changing the mine and flag images to something more fun!
  }
}

/*
 * Setup cells, place mines, start game timer
 */
void initializeGameData(){
  // Don't use height becuase it includes the game header
  rows = width / cellWidth;
  
  initializeImages();
  gameTimeSec = 0;
  
  if( startButton == null ){
    startButton = new Button("start", (width / 2) - 50, 0, 100, cellWidth);
  }
}

void initializeCells(){
  cells.clear();
  
  for( int i = 0; i < rows; i++ ) {
    for (int j = 0; j < rows; j++) {
      Cell c = new Cell(i, j);
      cells.add(c);
    }
  }
}

/*
 * Tracks game timer ~1 sec increments
 */
void updateGameTime(){
  if( gameInProgress ){
    if(millis() > nowMs + 1000) {
      gameTimeSec++;
      nowMs = millis();
    }
  }
}

/*
 * Draw top game header with # mines, start button, elapsed time
 */
void drawGameHeader(){
  // 8. Use the text("my text", x, y) function to draw the remaining number
  // of mines at the top of window
  //    - num_of_mines variable holds the total number of mines in the game
  //    - mines_flagged variable holds the number of mines that have been flagged
  //    - Use fill(color) to change the text color
  //    - Use textSize(int_size) to change the size of the text
  textSize(48);
  fill(0);
  
  if( numOfMines - minesFlagged > 0 ){ 
    text( (numOfMines - minesFlagged), 5, cellWidth - 5 );
  } else {
    text( "0", 5, cellWidth - 5);
  }
  
  // 9. Use the text("my text", x, y) function to draw the game time
  //    - game_time_sec variable holds the number of seconds since the game started
  text( gameTimeSec, width - 100, cellWidth - 5 );
  
  // 10. Call draw() from the start_button to draw the start button
  // Do you see the start button, mines left, and game timer?
  startButton.draw();
}

/*
 * Draw all cells
 */
void drawCells(){
  // 12. Use a for loop to go through each cell in the 'cells' list variable
  for( Cell c : cells ) {
    // 13. Call each cell's draw() method
    // Do you see the grid of cells?
    c.draw();
  }
}

/*
 * Initialize all game images
 */
void initializeImages(){
  empty = loadImage("empty.png");
  one = loadImage("1.png");
  two = loadImage("2.png");
  three = loadImage("3.png");
  four = loadImage("4.png");
  five = loadImage("5.png");
  six = loadImage("6.png");
  seven = loadImage("7.png");
  eight = loadImage("8.png");
  mineImg = loadImage("bomb.png");
  pinImg = loadImage("flag.png");
  wonImg = loadImage("sunglasses.png");
  lostImg = loadImage("cry.png");
  
  // Only add new images to the end of the array. The array index
  // is used to display the corresponding image for surrounding mines.
  images = new PImage[] {empty, one, two, three, four, five, six,
                         seven, eight, mineImg, pinImg, wonImg, lostImg};
                         
  for( PImage img : images ){
    img.resize(cellWidth, cellWidth);
  }
}

/*
 * Randomize mines in cells, set number of surrounding mines
 */
void initializeMines(){
  // Don't place any mines if more than the number of cells--invalid starting state
  if( numOfMines < (rows * rows) ){
    minesFlagged = 0;
    int minesPlaced = 0;
    
    while( minesPlaced != numOfMines ){
      Cell randCell = cells.get( (int)random(0, (rows * rows)) );
      
      if( !randCell.mine ){
        randCell.mine = true;
        minesPlaced++;
      }
    }
    
    gameReady = true;
  }

  // Set number of mines around each cell, zero to eight
  for( Cell cell : cells ) {
    List<Cell> neighbors = getNeighbors(cell);
    int mines = 0;

    for(Cell neighbor : neighbors) {
      if( neighbor.mine ) {
        mines++;
      }
    }
    
    cell.minesAround = mines;
  }
}

/*
 * Return list of all cells around specified cell
 */
List<Cell> getNeighbors(Cell cell) {
  List<Cell> neighbors = new ArrayList<Cell>();

  for( Cell c : cells ) {
    if( (c.i >= cell.i - 1) && (c.i <= cell.i + 1) &&
        (c.j >= cell.j - 1) && (c.j <= cell.j + 1) )
    {
      neighbors.add(c);
    }
  }

  return neighbors;
}

/*
 * Uncover cell (mine, number, or empty)
 */
void revealCell(Cell cell) {
  cell.revealed = true;

  // Hit mine, reveal all cells, game is over!
  if( cell.mine ) {
    for( Cell c : cells ) {
      c.revealed = true;
    }
    return;
  }

  // No mines around this cell, reveal all neighboring cells.
  // Do this until all neighboring cells with 0 surrounding mines are revealed
  if ( cell.minesAround == 0 ) {
    List<Cell> neighbors = getNeighbors(cell);
    
    for( Cell c : neighbors ) {
      if( !c.revealed ) {
        revealCell(c);
      }
    }
  }
}

/*
 * Win or lose, reveal all cells
 */
void gameEnd(String state) {
  gameInProgress = false;
  
  if( state.toLowerCase().equals( "won" ) ){
    mineImg = wonImg;
  }
  
  for( Cell c : cells ) {
    c.revealed = true;
  }
}

/*
 * Return the cell that the mouse is currently hovering over
 */
Cell checkCellPressed() {
  Cell cell = null;
  
  for( Cell c : cells ) {
    if( (c.x < mouseX) && (c.x + cellWidth > mouseX) &&
        (c.y < mouseY) && (c.y + cellWidth > mouseY) )
    {
      cell = c;
      break;
    }
  }
  
  return cell;
}

/*
* Right mouse button: flag cell
* Left mouse button: reveal cell (mine, number, or empty)
*/
void mousePressed() {
  if( startButton.mouseIsOver() ){
    initializeGameData();
    initializeCells();
    initializeMines();
    gameInProgress = true;
    return;
  }
  
  Cell cell = checkCellPressed();

  if( cell != null ){
    if( mouseButton == RIGHT ){
      if( !cell.revealed ){
        cell.pinned = !cell.pinned;
        minesFlagged++;
      }
    } else if( mouseButton == LEFT ){
      
      // Don't reveal pinned/marked cells. User must unpin to reveal.
      if( cell.pinned ){ 
        return;
      }
    
      revealCell(cell);

      if( cell.mine ){
        gameEnd("Lost");
      } else {
        // Check if player won the game
      
        int cellsLeft = 0;
        for( Cell c : cells ){
          if( !c.mine && !c.revealed ){
            cellsLeft++;
          }
        }
      
        if( cellsLeft == 0 ){
          gameEnd("Won");
        }
      }
    }
  }
}
