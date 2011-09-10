class BO_Attachment_Knife extends UTWeaponAttachment;

DefaultProperties
{
	begin object Name=SkeletalMeshComponent0
		SkeletalMesh=SkeletalMesh'MG_WP_Knife.Mesh.WP_Knife_1P'
		Translation=(X=0,Y=-2,Z=-5)
		Scale=1.f
	end object

	WeaponClass=class'BO_Weap_Knife'

	WeapAnimType=EWAT_Stinger

	MuzzleFlashSocket=MuzzleFlashSocket
}
