Feature: Dispatch Elevator to the right floor

  As a building occupant, I want the elevator system to automatically determine which elevator to send to my floor based
  on the number of people waiting for elevators, so that I can get to my destination as quickly and efficiently as possible.

  Rule: The closest lift should be dispatched to the floor that has the most people waiting for a lift.

    Example: All the lifts are empty
      We send the lifts to the closest target floor that has the most people waiting for a lift.
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy | Is Moving |
        | L1   | 5             | 0         | false     |
        | L2   | 5             | 0         | false     |
        | L3   | 3             | 0         | false     |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors |
        | 1     | 5                | 5                |
        | 2     | 2                | 1                |
        | 3     | 0                |                  |
        | 4     | 0                |                  |
        | 5     | 0                |                  |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor |
        | L2       | 1                   |
        | L3       | 2                   |

      Example: The one where people are waiting on more than 3 floors
        Given the following elevator configuration:
          | Lift | Current Floor | Occupancy | Is Moving |
          | L1   | 5             | 0         | false     |
          | L2   | 5             | 0         | false     |
          | L3   | 3             | 0         | false     |
        When the following people waiting for lifts:
          | Floor | Number of People | Requested Floors |
          | 1     | 5                | 5                |
          | 2     | 2                | 1                |
          | 3     | 1                | 1                |
          | 4     | 1                | 1                |
          | 5     | 1                | 1                |
        Then the elevators should be dispatched as follows:
          | Elevator | Dispatched To Floor |
          | L1       | 5,4,3,2,1           |
          | L3       | 1                   |

