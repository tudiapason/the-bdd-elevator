Feature: Dispatch Elevator to the right floor

  As a building occupant, I want the elevator system to automatically determine which elevator to send to my floor based
  on the number of people waiting for elevators, so that I can get to my destination as quickly and efficiently as possible.


  Rule: Prioritize the oldest floor request.

    Example: The one where floors are requested at different time
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy  | State | Target floor |
        | L1   | 5             | 0          | STOP  |              |
        | L2   | 5             | 0          | STOP  |              |
        | L3   | 5             | 0          | STOP  |              |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 1                | 5                | 1             |
        | 2     | 1                | 5                | 2             |
        | 3     | 1                | 5                | 3             |
        | 4     | 1                | 5                | 1             |
        | 5     | 0                | 0                |               |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor |
        | L1       | 5,1,5               |
        | L2       | 5,4,5               |
        | L3       | 5,2,5               |
      And the remaining people will be the first for the next available lift:
        | Floor | Number of People | Requested Floors | Request order |
        | 3     | 1                | 5                |1              |

  Rule: The closest lift should be dispatched to the floor that has the most people waiting for a lift.

    Example: All the lifts are empty
      _ We send the lifts to the closest target floor that has the most people waiting for a lift.
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy | State    | Target floor |
        | L1   | 5             | 0         | STOP     |              |
        | L2   | 5             | 0         | STOP     |              |
        | L3   | 3             | 0         | STOP     |              |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 5                | 5                | 1             |
        | 2     | 2                | 1                | 1             |
        | 3     | 0                |                  |               |
        | 4     | 0                |                  |               |
        | 5     | 0                |                  |               |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor |
        | L1       | 5,1,5               |
        | L3       | 3,2,1               |

    Example: The one where people are waiting on more than 3 floors
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy | State    | Target floor |
        | L1   | 5             | 0         | STOP     |              |
        | L2   | 5             | 0         | STOP     |              |
        | L3   | 3             | 0         | STOP     |              |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 5                | 5                | 1             |
        | 2     | 2                | 1                | 1             |
        | 3     | 1                | 1                | 1             |
        | 4     | 1                | 1                | 1             |
        | 5     | 1                | 1                | 1             |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor |
        | L1       | 5,4,1               |
        | L3       | 3,2,1,5             |

  Rule: Prioritize the elevator that will take the least amount of time to reach all requested floors.

    Example: The one with a shortest combination
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy  | State | Target floor |
        | L1   | 5             | 0          | STOP  |              |
        | L2   | 5             | 0          | STOP  |              |
        | L3   | 5             | 0          | STOP  |              |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 1                | 5                | 1             |
        | 2     | 1                | 5                | 1             |
        | 3     | 1                | 5                | 1             |
        | 4     | 1                | 5                | 1             |
        | 5     | 0                | 0                |               |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor |
        | L1       | 5,1,5               |
        | L2       | 5,2,5               |
        | L3       | 5,3,4,5             |

  Rule: Elevators can fit no more than 10 people (600 kg)

    Example: The one where a lift is almost full
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy | State | Target floor |
        | L1   | 2             | 8         | LOAD  | 5            |
        | L2   | 5             | 0         | STOP  |              |
        | L3   | 2             | 3         | LOAD  | 5            |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 1                | 3                | 1             |
        | 2     | 0                | 0                | 1             |
        | 3     | 1                | 5                | 1             |
        | 4     | 0                | 0                |               |
        | 5     | 0                | 0                |               |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor |
        | L1       | 2,5                 |
        | L2       | 5,1,3                |
        | L3       | 2,3,5               |

    Example: The one where most of the lifts are full and a floor with most people waiting for a lift.
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy | State | Target floor |
        | L1   | 5             | 0          | STOP |              |
        | L2   | 5             | 10         | STOP | 1            |
        | L3   | 1             | 10         | STOP | 5            |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 0                | 0                |               |
        | 2     | 7                | 5                | 1             |
        | 3     | 4                | 4                | 1             |
        | 4     | 2                | 5                | 1             |
        | 5     | 0                | 0                |               |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor|
        | L1       | 5,2,5              |
        | L2       | 5,1                |
        | L3       | 1,5                |
      And the remaining people will be the first for the next available lift:
        | Floor | Number of People | Requested Floors | Request order |
        | 3     | 4                | 4                | 1             |
        | 4     | 2                | 5                | 1             |

    Example: The one where most of the lifts are full and with individual destination changes.
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy | State    | Target floor |
        | L1   | 3             | 0          | STOP    |             |
        | L2   | 5             | 10         | STOP    | 1           |
        | L3   | 2             | 10         | STOP    | 1           |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 0                | 0                |               |
        | 2     | 2                | 1                | 1             |
        | 3     | 7                | 5                | 1             |
        | 4     | 3                | 5,2              | 1             |
        | 5     | 2                | 1                | 1             |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor|
        | L1       | 3,4,5,2,1          |
        | L2       | 5,1                |
        | L3       | 2,1                |

    Example: The one where only one lift is available for more than 10 people waiting in different floors
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy  | State | Target floor |
        | L1   | 5             | 0          | STOP  |              |
        | L2   | 5             | 0          | OOS   |              |
        | L3   | 5             | 0          | OOS   |              |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 8                | 5                | 1             |
        | 2     | 1                | 5                | 1             |
        | 3     | 1                | 5                | 1             |
        | 4     | 1                | 5                | 1             |
        | 5     | 0                |                  |               |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor|
        | L1       | 5,1,2,3,5,4,5      |

  Rule: Elevators send a voice message in case of lift capacity exceeded (10 people or >600 kg)

    Example: The one where only one lift is available for more than 10 people waiting in the same floor
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy  | State | Target floor |
        | L1   | 5             | 0          | STOP  |              |
        | L2   | 5             | 0          | OOS   |              |
        | L3   | 5             | 0          | OOS   |              |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 12               | 5                | 1             |
        | 2     | 0                | 0                |               |
        | 3     | 0                | 0                |               |
        | 4     | 0                | 0                |               |
        | 5     | 0                | 0                |               |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor |
        | L1       | 5,1                 |
      And System should sends a vocal message telling that the lift capacity has been exceeded

  Rule: Only Elevators stopped can be selected

    Example: The one where only 1 lift is stopped
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy  | State | Target floor |
        | L1   | 2             | 0          | UP    | 5            |
        | L2   | 5             | 0          | STOP  |              |
        | L3   | 2             | 0          | OOS   |              |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 1                | 3                | 1             |
        | 2     | 0                | 0                |               |
        | 3     | 1                | 5                | 1             |
        | 4     | 0                | 0                |               |
        | 5     | 0                | 0                |               |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor |
        | L1       | 2,5                 |
        | L2       | 5,1,3,5               |

  Rule: An Elevator can be put out of service and so never be selected

    Example: The one where 1 lift is out of service
      Given the following elevator configuration:
        | Lift | Current Floor | Occupancy  | State | Target floor |
        | L1   | 5             | 0          | STOP  |              |
        | L2   | 2             | 0          | OOS   |              |
        | L3   | 5             | 0          | STOP  |              |
      When the following people waiting for lifts:
        | Floor | Number of People | Requested Floors | Request order |
        | 1     | 1                | 3                | 1             |
        | 2     | 1                | 4                | 1             |
        | 3     | 1                | 5                | 1             |
        | 4     | 0                | 0                |               |
        | 5     | 0                | 0                |               |
      Then the elevators should be dispatched as follows:
        | Elevator | Dispatched To Floor |
        | L1       | 5,3,5               |
        | L3       | 5,1,2,3,4           |

