# Travelling Salesman Solver
### overview
This Ruby program is designed to solve the Traveling Salesman Problem (TSP) by finding the shortest possible route that visits a given set of cities exactly once and returns to the starting city. It takes an adjacency matrix, representing the distances or costs between each pair of cities, as input. The core of the program utilizes a dynamic programming approach

### Algorithm
The solver calculates the minimum cost to reach subsets of cities, storing these intermediate results through memoization. It uses a bitmask to represent the set of visited cities in each subproblem. The main logic first determines the optimal cost by considering all possible first "hops" from the starting city and then recursively calculating the best path through the remaining unvisited cities using the memoized dynamic programming function.

Once the minimum tour cost is identified, the program reconstructs the actual sequence of cities in the optimal path. This is achieved by backtracking through the decisions stored during the dynamic programming phase, identifying which "next city" led to the optimal sub-path at each step. Finally, the program outputs both the calculated minimum tour cost and the ordered list of cities that constitute this shortest route.

### How to Run
``` bash
cd Src
ruby tsp_solver.rb
```

### Input 
![image](https://github.com/user-attachments/assets/c19de8ef-7132-4f07-a40a-a5bb57202e78)

1. Masukan jumlah kota
2. Masukan edge untuk setiap kota (input dipisah dengan spasi)

### Output
![image](https://github.com/user-attachments/assets/5da8644d-5ce1-4087-ad22-e26053c331f7)

## Author
| Name               | Student ID | Institution                |
|--------------------|------------|----------------------------|
| Steven Owen Liauw  | 13523103   | Institut Teknologi Bandung |

## License
This project is part of the Algorithm Strategies course assignment (IF2211).
