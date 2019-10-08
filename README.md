# Finding Culprits
Program written and developed in the language Haskell as the first project for the subject COMP30020: Declarative Programming at the University of Melbourne - Semester 2, 2018.

### Goal

The aim of this project is to learn to program in the Functional programming language - Haskell, and to be able to reason critically to solve a logical problem. 


--- 

### Project Specs (A short simulated story)
There was a pursuit for the robbery criminals in progress, and the police has successfully detained a few suspects. There is a witness who recalls that there were two criminals, however he only remembers the characteristics of the criminals. Therefore, our job is to identify the culprits within the fewest guesses possible based on the characteristics described by the witness.

Three main characteristics: **height** (_Short_ - 'S', or _Tall_ - 'T'), **hair colour** (_Blonde_ - 'B', _RedHead_ - 'R', or _Dark haired_ - 'D'), and **gender** (_Male_ - 'M', or _Female_ - 'F').

### Tasks:
- First, we have the descriptions of the two true culprits in the format of a _2-tuple_, each value represented in a 3-letters string, with each letter correspond to a characteristic described. E.g. a short, blonde male and a short, redhead female are represented by **(SBM, SRF)**

- Then, we have to generate a _2-tuple_ guess, out of **66 maximum possible choices** (as there are only so many possible combinations of the three characteristics for two people).

- Next, a _feedback_ will be calculated based on our guess and the descriptions of the culprits. The feedback will be represented in the format of a _4-tuple_: with the first value corresponds to the number of culprits we've gotten right; second to the fourth values each representing the number of right guesses for height, hair colour, and gender respectively. 

E.g.

![feedback-format](https://github.com/nickangmc/culprits-guessing-game/blob/master/readme-images/feedback-format.png)


### Challenges Required:
1. To create a data structure to represent the culprits and guesses.
2. To parse a 2-tuple data structure into a maneuverable string, and vice versa.
3. To create feedback logic that takes in two 2-tuples and returns a 4-tuple scores.
4. To generate next guesses based on game state and feedback scores.
5. To verify that the right guesses are generated.

---

### Project Outcome
All the tasks and challenges within the scope of this project were completed. For all 66 possible tests, the program uses an average of 2.77 guesses to find all the culprits. 

