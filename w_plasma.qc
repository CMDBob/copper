/*
===============

PLASMA GUN

===============
*/

void(float damage) spawn_plashit =
{
	local vector	vel;

	vel = normalize(self.velocity) * -1;
	vel = normalize(vel + v_up*(random() + 0.5) + v_right*(random()- 0.5));
	
	particle (self.origin + vel, vel*0.1, 245, damage*2);
}

void() W_FirePlasma =
{
	local entity missile;
	local vector loc;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;
	
	makevectors (self.v_angle);
	loc = self.origin + v_forward * 8 + '0 0 16';
	
		missile = launch_rocket( loc, v_forward * 1000 );
		self.attack_finished = time + 0.8;
}