
set PLANES;

param max_seats {i in PLANES};
param max_weight {i in PLANES};

var standard{i in PLANES} integer;
var leisure{i in PLANES} integer;
var business{i in PLANES} integer;

# 19*standard(av1)+49*leisure(av1)+69*business(av1) + 19*standard(av2)+49*leisure(av2)+69*business(av2) + ...
maximize profit:
	sum{i in PLANES} (19 * standard[i] + 49 * leisure[i] + 69 * business[i]);

s.t. plane_seats {i in PLANES} : standard[i] + leisure[i] + business[i] <= max_seats[i];
s.t. plane_weight {i in PLANES} : standard[i] + leisure[i] * 20 + business[i] * 40 <= max_weight[i];
s.t. min_leisure {i in PLANES} : leisure[i] >= 20;
s.t. min_business {i in PLANES} : business[i] >= 10;
s.t. min_standard : sum{i in PLANES} standard[i] >= (sum{i in PLANES} max_seats[i]) * 0.6;
