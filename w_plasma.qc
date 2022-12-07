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
	
	self.currentammo = self.ammo_cells = self.ammo_cells - 1;
	
	sound (self, CHAN_WEAPON, "enforcer/enfire.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;
	
	makevectors (self.v_angle);
	loc = self.origin + v_forward * 8 + '0 0 16';
	
	missile = launch_plasma( loc, v_forward * 1000 );
	self.attack_finished = time + 0.2;
	self.cmd_flags |= CMDF_PLASMAFIRED;
}

void() plasma_touch =
{
	if (!CheckValidSpikeTouch()) return;
	
	if (self.dmg)
	{
		if (other.takedamage)
		{
			spawn_plashit (self.dmg);
			T_Damage (other, self, self.trueowner, self.dmg);
		}
		else
		{
			WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte (MSG_BROADCAST, TE_SPIKE);
			WriteCoord (MSG_BROADCAST, self.origin_x);
			WriteCoord (MSG_BROADCAST, self.origin_y);
			WriteCoord (MSG_BROADCAST, self.origin_z);
		}

		sound (self, CHAN_WEAPON, "enforcer/enfstop.wav", 1, ATTN_STATIC);
		particle (self.origin, self.velocity*-0.01, 245, 15);

	}
	// nonsense for combining quad SNG spike damage
	if (self.buddy)
		self.buddy.dmg = 0;
	remove(self);
}