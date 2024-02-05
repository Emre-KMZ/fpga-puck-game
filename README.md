# fpga-puck-game

# Air-Hockey FPGA Implementation - Readme

## Overview

Welcome to the Air-Hockey FPGA Implementation project. This project focuses on creating an electronic air-hockey game that can be played on an FPGA device (Nexys A7 is used in this project). The game requires two players and is designed to be implemented on a 1x5 LED display and few SSDs.

## Project Description

### Game Dynamics

- The game is played on a 5x5 field, representing the air-hockey field.
- Two players, A and B, take turns hitting a virtual puck using buttons and switches on the FPGA device.
- LEDs simulate the puck's movement from right to left, and the seven-segment display shows the Y-coordinate of the puck.

### Turn Structure

1. **Player A's Turn:**
   - Player A initiates the game by setting the initial score using buttons and switches.
   - After the initial setup, LD15 signals that Player A should input the Y-coordinate and direction for the puck.
   - The puck starts moving, and LD15 turns off. The puck takes 2 seconds to reach the right-most column.

2. **Player B's Turn:**
   - LD0 signals Player B to input the Y-coordinate and direction before the puck reaches the right-most column.
   - Player B adjusts the switches and hits the puck, initiating its movement from right to left.
   - LD0 turns off, and the turn shifts back to Player A.

3. **Game Progression:**
   - Players take turns hitting the puck until one player scores three goals, declaring them the winner.
   - The game displays the current score, winner, and LD9-LD5 blink with a 1-second period to signify the end of the game.
