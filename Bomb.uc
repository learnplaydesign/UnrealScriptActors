class Bomb extends Actor
	ClassGroup(Common)
	placeable;

	/* Declare editable variables */
	var() const editconst DynamicLightEnvironmentComponent BombLightEnvironment;
	var() StaticMeshComponent BombMesh;
	var() float Radius;
	var() float Damage;
	
	/* Checks for all Pawns within a certain radius of the bomb */
	function checkPawns(float checkRadius)
	{
		local Pawn P;
		
		/* itterate through all Pawns in the level*/
		foreach WorldInfo.AllPawns(class'Pawn', P)
		{
			if(VSize(self.location - P.location) < checkRadius)
			{
				Explode();
			}
		}
	}
	
	/* Every tick call the checkPawns function */
	function Tick(float DeltaTime)
	{
		checkPawns(Radius);
	}
	
	/* Hurt player within radius */
	function Explode()
	{
		local Pawn P;
		
		//Each Actor in radius take damage.
		foreach OverlappingActors(class'Pawn',  P, Radius) 
		{
			if(P != none)
			{
				/* Each pawn within 'Radius' takes 'Damage' using the Rock Damage Type
				   400 Momentum is applied from the origin of the Bombs location.
				*/
				HurtRadius(Damage, Radius, class'UTDmgType_Rocket',  400, self.location);
			}
			
		}	
	}
	
	defaultproperties
	{
		/* Default Radius and Damage */
		Radius = 256
		Damage = 100
		
		/* Add Static Mesh Component */
		begin object class=StaticMeshComponent name=BMesh
			BlockActors = true;
			StaticMesh = StaticMesh'f029546aPackage.Sphere'
			CastShadow = true
		end object
		
		CollisionComponent = BMesh
		BombMesh = BMesh;
		Components.Add(BMesh);
		
	}