set PLANES;
set TIMESLOTS;

# -----			-----
# -----   PARAMETERS	-----
# -----			-----

# -----	  Problem 1	-----

# Maximum seat amount per plane
param max_seats {i in PLANES};

# Maximum total weight of luggage per plane
param max_weight {i in PLANES};

# -----	  Problem 2	-----

# The cost in euros per minute for every plane
param plane_cost{j in PLANES};

# Minutes on the air per plane per timeslot. 99999 means infinite cost,
# so that planes are not assigned to that timeslot due to unavailable
# runways or landing schedule not coinciding.
param unit_cost{i in TIMESLOTS, j in PLANES};

# -----			-----
# -----    VARIABLES	-----
# -----			-----

# -----	  Problem 1	-----

# Standard, leisure and business class tickets
var standard{i in PLANES} integer;
var leisure{i in PLANES} integer;
var business{i in PLANES} integer;

# -----	  Problem 2	-----

# Binary matrix, assigns planes to time slots
var assign{i in TIMESLOTS, j in PLANES} binary;

# -----				-----
# -----    OBJECTIVE FUNCTION	-----
# -----				-----

# Maximize the income of tickets while minimizing costs of landing scheduling
maximize profit:
	(sum{i in PLANES} (19 * standard[i] + 49 * leisure[i] + 69 * business[i]))
	- (sum{i in TIMESLOTS, j in PLANES} (unit_cost[i, j] * plane_cost[j] * assign[i, j]));

# ----- CONSTRAINTS -----

# Problem 1

# For every plane their class tickets must not exceed maximum seat capacity
s.t. plane_seats {i in PLANES} : standard[i] + leisure[i] + business[i] <= max_seats[i];

# For every plane, their combined class ticket luggage weights must not exceed plane maximum weight
s.t. plane_weight {i in PLANES} : standard[i] + leisure[i] * 20 + business[i] * 40 <= max_weight[i];

# For every plane there must be at least 20 leisure tickets
s.t. min_leisure {i in PLANES} : leisure[i] >= 20;

# For every plane there must be at least 10 business tickets
s.t. min_business {i in PLANES} : business[i] >= 10;

# For every plane there must be at least 60% of standard tickets 
s.t. min_standard : sum{i in PLANES} standard[i] >= (sum{i in PLANES} max_seats[i]) * 0.6;

# Problem 2

# For every plane there must be a timeslot assigned
s.t. constraint_timeslots{j in PLANES} :
	sum{i in TIMESLOTS} assign[i, j] = 1;

# For every timeslot there *could* be a plane (one at max) assigned to it
s.t. constraint_planes{i in TIMESLOTS} :
	sum{j in PLANES} assign[i, j] <= 1;
