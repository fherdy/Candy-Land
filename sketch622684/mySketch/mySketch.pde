/* @pjs preload="die.png", "candy.jpg"; */


/*Global Variables*/
int screenVal = 0;
int player1;
int p1Score;
int p2Score;
int round;
int WS = 100;
int HS = 100;
color[] temp = colorArray();

GameBoard g; //g.p1 refers to player1
String winningPlayer = "";

/*Images*/
PImage candy;
PImage die;

void setup()
{
  size(900,700);
	g = new GameBoard(gameBoardMath());
	candy = loadImage("candy.jpg");
  candy.resize(0,height-200);
  
  die = loadImage("die.png");
  die.resize(100,100);
}

void draw()
{
  //Intro screen
  if(screenVal == 0)
  {
    startScreen();
  }
  
  //Upon pressing h or H user will be introduced to the help screen with full game instructions
  else if(screenVal == 1)
  {
    howToPlayScreen();
  }
  
  //The game screen
  else if(screenVal == 2)
  {
    gameScreen();
  }
  
  //Once winning condition is met the game will end and user results will be displayed
  else if(screenVal == 3)
  {
    gameOverScreen();
  }
}

void keyPressed()
{
  if(key == ENTER)
  {
    if(screenVal == 0 || screenVal == 1)
    {
      startGame();
    }
  }
  
  if(key == 'h' || key == 'H')
  {
    screenVal = 1;
  }
	
	if ((key == 'q' || key == 'Q')){
			if (!g.p1.specialPowerUsed && screenVal == 2 && g.p2.position > 2) {
				g.p1.useSpecialPower();
				g.p2.roll3();
				redraw();
			}
	}
	
	if (key == 'p' || key == 'P') {
		if (!g.p2.specialPowerUsed && screenVal == 2 && g.p1.position > 2) {
			g.p2.useSpecialPower();
			g.p1.roll3();
			redraw();
		}
	}
	

}

void mousePressed()
{
  
  if(mousePressed==true  && mouseX<=100 && mouseY>=550 && mouseY<=650)
  {
		if(round%2==0) {
			text("Player 1's turn", 420, 580);
			g.p1.roll();
		} else {
			text("Player 2's turn", 420, 580);
			g.p2.roll();
		}
		
    textAlign(CENTER);
    textSize(16);
    fill(0);

    width=width+30;
  
    
  
    if(player1%2==0)
    {
      text("PLAYER1  ",width/3,height-100);
      text(g.p1.position,(width/3)+50,height-100);
    }
    else if (player1%2==1)
    { 
      text("PLAYER1  ",width/3,height-100);
      text(g.p1.position,(width/3)+50,height-100);
    }
  }
	redraw();
	round++;
}

void startScreen()
{
  background(0);
  textAlign(CENTER);
  textSize(14);
  text("Press Enter to start!", 450, 350);
  text("Press H to see how to play", 450, 450);
}

void howToPlayScreen()
{
  background(0);
  textSize(14);
  text("Instructions", 450, 20);
  text("Rules:", 100, 100);
  text("- 2 Players", 120, 120);
  text("- On each turn players must click on the die, the die will return a value in the", 320, 140);
  text("range of 1 to 6.These values will determine your movement on the gameboard.", 340, 160);
  text("- If an odd number is rolled, Player will move backward.", 275, 180);
  text("- If an even number is rolled, Player will move forward.", 270, 200);
  text("Goal: ", 100, 240);
  text("- Reach the last square on the gameboard to make it to Candy Castle!", 320, 260);
  text("Press Enter when you are ready to begin!", 450, 400);
}

void gameScreen()
{
	textSize(16);
  background(255);
  //fill(0);
  
  image(candy,0,0);
  loadPixels();
  candy.loadPixels(); 
  
  image(die,0,550);
  loadPixels();
  die.loadPixels();
  
  noLoop();
	
  gameBoard();
	g.draw();
  
	fill(0);
	if(round%2==0) {
			text("Player 1's turn", 450, 540);
		} else {
			text("Player 2's turn", 450, 540);
		}
	text("Player 1 rolled a " +g.p1.lastResult , 450, 580);
	text("Player 2 rolled a " +g.p2.lastResult , 450, 600);
  text("Round# " + round, 800, 540);
  text("P1Score: " + g.p1.position, 800, 580);
  text("P2Score: " + g.p2.position, 800, 600);
	
}

void startHelp()
{
  screenVal = 1;
}

void startGame()
{
  screenVal = 2;
	gameBoard();
}

void gameOverScreen()
{
	background(0);
	fill(255);
	
	text("Game Finished", 450, 300);
	text(winningPlayer + " has reached Candy Castle!", 450, 350);
	text("P1 Final Score: " + g.p1.position, 450, 400);
  text("P2 Final Score: " + g.p2.position, 450, 450);
}

float[][] gameBoardMath()
{
	float[][] coords = new float[29][2];
	int x = 0;
  int y = 0;
	
	for(int i = 0; i<29;i++){
		coords[i][0]=x+WS/2;
		coords[i][1]=y+HS/2;
		
		if(x < 800 && y == 0){  
			x+=100;
		}
			else if(x == 800 && (y == 0 || y <200)){  
				y+=100;
			}
				else if(y == 200 && x > 0){
					x-=100;
				}
					else if(x == 0 && (y == 200 || y < 400)){
						y+=100;
					}
						else if(y == 400 && x < 900){
							x+=100;
						}
	}
  
	return coords;
}

void gameBoard()
{
	int x = 0;
  int y = 0;
	temp[g.bridge1] = color(255);
	temp[g.bridge2] = color(255);
	
	for(int i = 0; i<29;i++){
	fill(temp[i]);
	rect(x,y,WS,HS,20);
	if(x < 800 && y == 0){  
			x+=100;
		}
			else if(x == 800 && (y == 0 || y <200)){  
				y+=100;
			}
				else if(y == 200 && x > 0){
					x-=100;
				}
					else if(x == 0 && (y == 200 || y < 400)){
						y+=100;
					}
						else if(y == 400 && x < 900){
							x+=100;
						}
		
		
	}
	
}

public boolean checkWinner(){
	if (g.p1.position == 28)
		winningPlayer = "Player 1";
	if (g.p2.position == 28)
		winningPlayer = "Player 2";
	return (g.p1.position == 28) || (g.p2.position == 28);
}

//Color Array with randomly generated colors
color[] colorArray()
{
  int i;
  color[] cArr = new color[29];
	// r, g, b, y
  color[] possibleColors = {color(255,0,0,128), color(0,255,0,128), color(0,0,255,128), color(255,255,0,128)};
  for(i = 0; i <= 29; i++)
  {
    cArr[i] = possibleColors[(int)(random(4))];
  }
  
  return cArr;
}

class Player {
	int lastResult;
  int position;
  color c;
  float r;
  float[][] coordinates;
	boolean specialPowerUsed = false; 
  
  // Player constructor, picks a random color and size between 15 and 50
  public Player(float[][] coord) {
    this.position = 0;
    this.c = color(random(0, 255), random(0, 255), random(0, 255));
    this.r = random(50,70);
    coordinates = coord;
  }
  
  // draws the player at the right space
   public void draw() {
    fill(c);
    ellipse(getX(),getY(),r,r);
  }
  
  public void roll() {
		lastResult = (int)(random(5)+1);
		if (lastResult == 3){
			if (position > lastResult)
    		position -= lastResult;
		}
		else
			position += lastResult;
		
		if (position >28)
			position = 28;
		
		checkBridge();
		if (checkWinner()){
			screenVal = 3;
		}
  }
  
	public void roll3() {
		lastResult = 3;
		if (position > lastResult)
    	position -= lastResult;
		checkBridge();
	}
	
public void checkBridge() {
	if (this.position == g.bridge1){
		this.position = g.bridge2;}
	else if (this.position == g.bridge2){
		this.position = g.bridge1;}
}
  // getX and getY will use the integer position and return what
  // coordinates on the board it'll draw to. I'll probably store
  // the points in a hash map, or figure out some formula to map
  // the squares 0-30 to the center of each square we drew.
  public float getX() {
    return coordinates[position][0];
  }
  public float getY() {
    return coordinates[position][1];
  }
  
	public void useSpecialPower(){
		specialPowerUsed = true;
	}
}

class GameBoard {
  int[] board;
  Player p1;
  Player p2;
	int bridge1;
	int bridge2;
  float[][] coordinates;
  
  // GameBoard constructor, creates the board array and 2 new players
  public GameBoard(float[][] coord) {
    // Size 31 because there are 31 square on the board
    this.board = new int[29];
    this.p1 = new Player(coord);
    this.p2 = new Player(coord);
		bridge1 = int(random(10))+5;
		bridge2 = int(random(9))+17;
    coordinates = coord;
  }
  
  // Draws the bigger player, then the smaller one (so we can see them!)
  public void draw() {
    if (p1.r > p2.r) {
     p1.draw(); p2.draw();
    } else {
     p2.draw(); p1.draw();
    }
	}

}