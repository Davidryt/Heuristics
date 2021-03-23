
set PLANES;
set TIMESLOTS;

param plane_cost{j in PLANES};
param unit_cost{i in TIMESLOTS, j in PLANES};

var assign{i in TIMESLOTS, j in PLANES} binary;

minimize cost:
	sum{i in TIMESLOTS, j in PLANES}
		(unit_cost[i, j] * plane_cost[j] * assign[i, j]);
/*
s.t. constraint_planes{i in TIMESLOTS} :
	sum{j in PLANES} assign[i, j] = 1;
s.t. constraint_timeslots{j in PLANES} :
	sum{i in TIMESLOTS} assign[i, j] = 1;*/

s.t. constraint_timeslots{j in PLANES} :
	sum{i in TIMESLOTS} assign[i, j] = 1;
