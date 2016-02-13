pro cmd_plot, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, col1=col1, col2=col2, $
mag_glob=mag_glob, $
mag_appvec_inf=mag_appvec_inf, mag_appvec_sup=mag_appvec_sup, col_appvec_inf=col_appvec_inf, col_appvec_sup=col_appvec_sup, $
mag_absvec_inf=mag_absvec_inf, mag_absvec_sup=mag_absvec_sup, col_absvec_inf=col_absvec_inf, col_absvec_sup=col_absvec_sup, $
help=help
; 
; - - Procedure to plot both App. and Abs. CMD from output of population synthesis tool 
; 
;	NOTES: 
;		- Colour and magnitude restrictions dependant on CMD vector values, found
;		  within Globals.f90 within $arch_dir$+'/Code/Globals.f90' (~L52:61) 
;		- If log(g) cuts are made, edit $filein2$ with reasonable filename definition (~L111)
;		- Edit Hard-coded mag. restriction oplotting if required (~L137)
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
if (keyword_set(help) eq 1) then begin
   Message, 'Usage:',/info
   Message, 'cmd_plot, arch_dir=arch_dir, sim1=sim1, sim2=sim2', /info
   Message, '	tag=tag, col1=col1,col2=col2, mag_glob=mag_glob,', /info
   Message, '	col_down=col_down, col_up=col_up, mag_down=mag_down, ', /info
   Message, '	mag_up=mag_up, help=help', /info
   Message, 'Purpose: Plot App. and Abs. CMD of population synthesis', /info
   Message, 'Input:   arch_dir = Directory source for SynCMD', /info
   Message, '	      sim1 = Simulation to be used (MUGS or MaGICC)', /info
   Message, '	      sim2 = Simulation iteration to be used (g1536 or g15784)', /info
   Message, '	      tag = SynCMD tag associated with analysis run', /info
   Message, '	      col1 = Colour #1 used within CMD analysis', /info
   Message, '	      col2 = Colour #2 used within CMD analysis', /info
   Message, '	      mag_glob = Magnitude scale used for CMD analysis', /info
   Message, '	      $i$_$j$ ($i$=[col, mag],$j$=[up,down]) = Restrictions', /info
   Message, '	      on both color and magnitude within CMD', /info
   Message, 'Outputs: Apparent and Absolute mag. CMD', /info
   Message, '	      within:', /info
   Message, '	      $arch_dir$/PLOTS/CMD/$i$+$col1$+$col2$+_+$mag_glob$+$sim1$+$sim2$+$tag$+CMD.eps', /info
   return
endif
;
;		
	; - - - VARIABLE DEFINITIONS - - - ;
;
		; - - - Note, these limits are dependant on the colour and magnitude restrictions
		; - - - on CMD vector values, found within Globals.f90 within
		; - - - $arch_dir$+'/Code/Globals.f90'
;
	col_absvec_sup=3
	col_absvec_inf=-1
	mag_absvec_sup=9
	mag_absvec_inf=-6
	col_appvec_sup=5
	col_appvec_inf=-1
	mag_appvec_sup=30
	mag_appvec_inf=-1
	arr_abs=((col_absvec_sup-col_absvec_inf)/0.05)*((mag_absvec_sup-mag_absvec_inf)/0.05)
	arr_app=((col_appvec_sup-col_appvec_inf)/0.05)*((mag_appvec_sup-mag_appvec_inf)/0.05)
;
	; - - - MAIN  PROGRAM - - - ;
;
loadct, 39
set_plot,'ps'
filename1=arch_dir+'PLOTS/CMD/'+col1+col2+'_'+mag_glob+'_'+sim1+sim2+'_'+tag+'_ABS.eps'
device,/encapsulated,file=filename1, xsize=12, ysize=12, /inches,/color
;
x=fltarr(arr_abs)
y=fltarr(arr_abs)
z=fltarr(arr_abs)
filein1=arch_dir+'Outputs/CMDOut/'+col1+col2+'_'+mag_glob+'_CMDOUT'+sim1+sim2+'_'+tag+'_ABS.dat'
openr,lun,filein1,/get_lun
;
for j=0L,arr_abs-1 do begin
	readf,lun,tmp1,tmp2,tmp3
	x(j)=tmp1
	y(j)=tmp2
	z(j)=tmp3
endfor
;
w=alog10(z+1)
triangulate, x, y, tri
grid=trigrid(x,y,w,tri,missing=0,xgrid=xvector,ygrid=yvector, nx=10000, ny=10000)  
levels=12
step=(max(grid)-min(grid))/levels
userlevels=indgen(levels)*step+min(grid)
loadct, 5, ncolors=12, bottom=3
contour,grid, xvector, yvector, yrange=[mag_absvec_sup,mag_absvec_inf], $
	/fill, position=[0.1,0.1,0.9,0.80], $
	levels=userlevels, C_Colors=IndGen(levels)+3, $
	xtitle=col1+"-"+col2, $
	ytitle=mag_glob, ystyle=1, charsize=2, xrange=[col_absvec_inf,col_absvec_sup], xstyle=1
;
cgColorbar, Divisions=floor(alog10(max(grid))), Range=[Min(grid),Max(grid)], Format='(I4)', $
	Position=[0.88, 0.15, 0.9, 0.8], NColors=12, Bottom=3, $
	title=textoidl("Contour Legend (log_{10}(\nu))"), charsize=1
;
device,/close
set_plot,'X'
free_lun, lun
;
;
loadct, 39
set_plot,'ps'
filename2=arch_dir+'PLOTS/CMD/'+col1+col2+'_'+mag_glob+'_'+sim1+sim2+'_'+tag+'_APP.eps'
device,/encapsulated,file=filename2, xsize=12, ysize=12, /inches,/color
;
x=fltarr(arr_app)
y=fltarr(arr_app)
z=fltarr(arr_app)
;
filein2=arch_dir+'Outputs/CMDOut/'+col1+col2+'_'+mag_glob+'_CMDOUT'+sim1+sim2+'_'+tag+'_APP.dat'
openr,lun,filein2,/get_lun
;
for j=0L,arr_app-1 do begin
	readf,lun,tmp1,tmp2,tmp3
	x(j)=tmp1
	y(j)=tmp2
	z(j)=tmp3
endfor
w=alog10(z+1)
triangulate, x, y, tri
grid=trigrid(x,y,w,tri,missing=0,xgrid=xvector,ygrid=yvector, nx=10000, ny=10000)  
levels=12
step=(max(grid)-min(grid))/levels
userlevels=indgen(levels)*step+min(grid)
loadct, 5, ncolors=12, bottom=3
;contour,grid, xvector, yvector, yrange=[mag_appvec_sup,mag_appvec_inf], $
contour,grid, xvector, yvector, yrange=[24.99,0.01], $
/fill, position=[0.1,0.1,0.9,0.80], $
levels=userlevels, C_Colors=IndGen(levels)+3, $
xtitle=col1+"-"+col2, $
;ytitle=mag_glob, ystyle=1, charsize=2, xrange=[col_appvec_inf,col_appvec_sup], xstyle=1
ytitle=mag_glob, ystyle=1, charsize=2, xrange=[-0.49,4.99], xstyle=1
;
	; - - - Hard-coded edits for visulation of restrictions + log(g) restriction tag
;
oplot, [col_appvec_inf,col_appvec_sup],[14,14], linestyle=0, thick=10, color=255
oplot, [col_appvec_inf,col_appvec_sup],[12,12], linestyle=0, thick=10, color=255
;meanings='GB Population'
;al_legend,meanings,/right,/top, charsize=1.5, background=255
;
cgColorbar, Divisions=floor(alog10(max(grid))), Range=[Min(grid),Max(grid)], Format='(I4)', $
Position=[0.88, 0.15, 0.9, 0.8], NColors=12, Bottom=3, $
title=textoidl("Contour Legend (log_{10}(\nu))"), charsize=1
;
device,/close
set_plot,'X'
free_lun, lun
;
end
