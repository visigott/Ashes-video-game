# ASHES
### Video Demo: https://youtu.be/3d8gL_y3_GM
## Description: 
For CS50x's final project, I coded a game with LÖVE framework. This game is a dark fantasy and a little nightmare-ish hypercasual game. Our main character is fighting against nightmares and gains scores. There are six lua files that I wrote and a lua file that I imported as helper. For all the images and animations I used Stable Diffusion mainly; Aseprite and Adobe Photoshop to support Stable Diffusion. I learnt LÖVE framework and all these game making proccess from https://sheepolution.com/learn and got help from ChatGPT.

## Brief Descriptions for the files.
### **classic.lua(helper):**
Makes lua language object oriented. ref: https://github.com/rxi/classic


### **main.lua:** 
Main menu file.
In love.load(): 
    function; game logo, font, main menu background image and making of buttons and their functions are implemented.

In love.update(dt) function; there is an if statement checking if Start Button is clicked or not and if it is clicked it brings game.lua file. Within that if statement there is game.update(dt) function is running. If player.health goes to 0 or below. It returns the menu with the last score of the player. So the score is displayed on menu after player dies.

In love.draw() function; buttons and backgrounds are being displayed its more likely a HTML, CSS kind of function.



### **game.lua:**
In-game main file. 
Game.load() function: imports other lua files, font, background image, constructs player character, creates a list of bullets and a list of enemies, and enemy spawn timer variables and such.

There is a function named love.mousepressed(x, y, button) takes the clicking coordinates of left mouse button and creates a bullet that goes towards that coordinates. Passes those inputs to Bullet.lua constructor.

There is a keypressed function that takes the key which is pressed as input, if its space, makes the player dash towards the mouse pointer's current position

In game.update(dt): *There is a statement that returns score to the menu. *Player.lua's update function. *A hardening handler that in every 100 hundred scores, it gives player 1 HP and enemies spawn faster. An enemy spawner implementation. A player jumping handler. Bullet mechanics updater. Enemy mechanics and collision with player updater. And player flags that checks the condition of player such as whether if its dashing or in air.

In Game.draw(): Handles all the objects, HUD and background to be seen.

### **player.lua:**
This is the file for playable character.  
First it extends the Object function of helper file named classic.lua -which makes lua language an OOP language-. 
In constructor function of Player, there is animation frames and all other variables player needs are being loaded.
In player:update(dt): there is hitbox handler and animation handler codes at the beginning. Then moving left and right are being handled. self.isLeft boolean variable makes our character turn to the last direction he moved at the player.draw() function.
And then there is jumping handler which is quite cool because implemented exactly like real physics. And then wallCollision function's handler. 
There are dash, wallCollision and jump functions that are implemented outside the update function. they are being called where its needed.
In player:draw() function, there is an if, elseif statement that checks whether self.isLeft true or not to direct the character's current frame to the left or right.
Briefly, character has walking and jumping animation besides standing. Can throw daggers, jump, and dash.


### **enemy.lua:**
This is the file where enemies' all properties and functions are.  In constructor function, there is an algorithm that makes enemies spawn outside of the container. Every enemy are actually the same but they get random sprites among three which are the heads of Elon Musk, Jeff Bezos and Mark Zuckerberg. Enemies chase the player, every time they get damage they get faster.There is checkCollision function of its own takes input any object so its used with daggers and player. Also there is an aggro function that makes sure enemy is always going to players current location.
Enemies are the nightmare fuels of our game.


### **bullet.lua:**
This is the throwing dagger's file. in constructor function it has its own attributes. Has its own checkCollision(bullet, obj) function. In Bullet:update(dt) function, there is codes to direct this bullet(dagger) to the right angle. In draw function dagger is rendered to turn the destination point of bullet.


### **animations:**
I used Stable Diffusion for all the images that can be seen in the game. Frames are made with the help of openpose extension of Stable Diffusion. I first made the poses and added them end to end in one photo with Adobe Photoshop which made it an animation sheet. And then with ControlNet Openpose extension of Stable diffusion, some pixel art LORA option and right prompting I made the sheet for main character's frames. I resized the images with Aseprite for the correct hitboxes and such. I'll add a folder only for the image making proccess. For animations this guy helped a lot: https://www.youtube.com/watch?v=ismWniiT8ew&t=647s

