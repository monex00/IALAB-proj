#solve 8 queens problem using A* algorithm

# return the number of pairs of queens that are attacking each other
def heuristic(state):
    pairs = 0
    for i in range(len(state)):
        for j in range(i+1, len(state)):
            if state[i] == state[j]:
                pairs += 1
            if abs(state[i] - state[j]) == abs(i - j):
                pairs += 1
    return pairs

def AStarSearch(state, heuristic):
    open = [state]
    closed = []
    while open:
        open.sort(key=heuristic)
        state = open.pop(0)
        closed.append(state)
        if heuristic(state) == 0:
            return state
        for i in range(len(state)):
            for j in range(len(state)):
                if state[i] != j: # if the queen is not already in this column
                    newState = state[:] # copy the state
                    newState[i] = j
                    print(newState)
                    if newState not in open and newState not in closed:
                        open.append(newState)
    return None

def main():
    state = [0,1,2,3]
    solution = AStarSearch(state, heuristic)
    if solution:
        print(solution)
    else:
        print("No solution found")

if __name__ == "__main__":
    main()
