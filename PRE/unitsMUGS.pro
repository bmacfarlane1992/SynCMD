pro unitsMUGS,g,d,s,a

ms_units=4.7526e16                
dist_units=6.84932e4*a                                    
v_units=1670.2*a
sysamucc = 6.0294915e-06*a^3


s.mass=ms_units*s.mass
g.mass=ms_units*g.mass
d.mass=ms_units*d.mass

s.tform=13.74/0.354154*s.tform
s.phi=v_units*v_units*s.phi

g.x=dist_units*g.x
g.y=dist_units*g.y
g.z=dist_units*g.z
d.x=dist_units*d.x
d.y=dist_units*d.y
d.z=dist_units*d.z
s.x=dist_units*s.x
s.y=dist_units*s.y
s.z=dist_units*s.z

g.vx=v_units*g.vx
g.vy=v_units*g.vy
g.vz=v_units*g.vz
d.vx=v_units*d.vx
d.vy=v_units*d.vy
d.vz=v_units*d.vz
s.vx=v_units*s.vx
s.vy=v_units*s.vy
s.vz=v_units*s.vz



return

end
