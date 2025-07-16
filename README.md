# ThiefBuster2DGame
this is main repository for developing 2D hyper-casual game, with the idea player as a bank guard has to hit the thieves in order to survive

## Coding Agreement
To maintain code consistency across the project, follow these naming conventions:

- **Variable**: 
  - Use camelCase for variable names (e.g., `playerScore`, `enemySpeed`).
- **Function**: 
  - Use camelCase for function names (e.g., `calculateScore()`, `spawnEnemy()`).
  - Start with a verb to indicate the action (e.g., `calculateSpeed()` instead of `speedCalculation()`).
  - Ensure each function has one clear purpose.
  - Use clear and unambiguous names that define the function's purpose. (e.g., `calculateScore()` instead of `calculate()` )
- **Class**: 
  - Use PascalCase for class names (e.g., `GameManager`, `CollisionManager`).

- **File naming**: 
  - Use PascalCase for file names matching the primary class or module (e.g., `GameManager.swift`, `Player.swift`).

## How to Contribute
1. Clone the repository to your local machine.
2. Create a new branch from the `develop` branch for your feature or bug fix: `git checkout -b feature/feature-name develop`.
3. Make your changes and commit them with clear and descriptive messages following these rules:
   - Use `feat: description` for new features.
   - Use `fix: description` for bug fixes.
   - Use `docs: description` for documentation updates.
   - Use `refactor: description` for code refactoring.
   - Use `test: description` for adding or updating tests.
4. Push your changes to the repository: `git push origin feature/feature-name`.
5. Open a pull request to the `develop` branch of this repository.
   - Assign at least one reviewer to your pull request.
6. Wait for the review and address any requested changes.
