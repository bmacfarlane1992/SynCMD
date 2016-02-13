pro extinct_ts, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, cutcount=cutcount, help=help
; 
; - - Procedure written to analyse extinction profile as determined within premain.pro 
; - - module extinct.pro
; - - This will in essence determine the level of consistency within the geometric approach in
; - - calculating N(H)
; 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
if (keyword_set(help) eq 1) then begin
   Message, 'Usage:',/info
   Message, 'extinct_ts, arch_dir=arch_dir, sim1=sim1, sim2=sim2', /info
   Message, '	tag=tag, cutcount=cutcount, help=help', /info
   Message, 'Purpose: Read simulation star selection filename', /info
   Message, '         to population synthesis input file', /info
   Message, 'Input:   arch_dir = Directory source for SynCMD', /info
   Message, '	      sim1 = Simulation to be used (MUGS or MaGICC)', /info
   Message, '	      sim2 = Simulation iteration to be used (g1536 or g15784)', /info
   Message, '	      tag = SynCMD tag associated with analysis run', /info
   Message, 'Outputs: ', /info
   return
endif
;
;		
	; - - - VARIABLE DEFINITIONS - - - ;
;
;
	; - - - MAIN  PROGRAM - - - ;
;
starnum=cutcount(0)
;
filename=arch_dir+'Inputs/CMDSTARS'+sim1+sim2+'_'+tag+'.dat'
openr,lun,filename,/get_lun
;
x=fltarr(starnum)
y=fltarr(starnum)
z=fltarr(starnum)
l=fltarr(starnum)
b=fltarr(starnum)
d=fltarr(starnum)
n_h=fltarr(starnum)
sav=fltarr(starnum)

for i=0L, starnum-1 do begin
	readf, lun, tmp1,tmp2,tmp3,tmp4,tmp5,tmp6,tmp7,tmp8,tmp9,tmp10, $
		tmp11,tmp12,tmp13,tmp14,tmp15,tmp16,tmp17,tmp18,tmp19,tmp20, $
		tmp21,tmp22,tmp23,tmp24,tmp25,tmp26
	x(i)=tmp1
	y(i)=tmp2
	z(i)=tmp3
	l(i)=tmp22
	b(i)=tmp23
	d(i)=tmp24
	n_h(i)=tmp25
	sav(i)=tmp26
endfor
free_lun, lun
;
		; - - - Begin analysing distributions of extinction vs. distance measures
;
set_plot,'ps'
device, /encapsulated, file=arch_dir+'PLOTS/EXTINCT/sav_hist.eps', xsize=16, $
	ysize=8, /inches, /color
!p.multi=[0,2,1]
d_hist=histogram(d, binsize=0.25, locations=xbin_d)
d_hist=d_hist/starnum
sav_hist=histogram(sav,binsize=0.25,locations=xbin)
sav_hist=sav_hist/starnum  
plot, xbin_d, d_hist, psym=10, title='Distance, d (kpc) distribution', $
	xtitle='Radial distance from obsever (kpc)', ytitle='Composite star number'
plot, xbin, sav_hist, psym=10, title='SaV (mag.) distribution', $
	xtitle='Extinction, SaV (mag.)', ytitle='Composite star number'
device,/close
set_plot,'X'
;
;
set_plot,'ps'
device, /encapsulated, file=arch_dir+'/PLOTS/EXTINCT/sav_spatial.eps', xsize=16, $
	ysize=8, /inches, /color
!p.multi=[0,2,1]
loadct,0
xdum=[0,0]
ydum=[0,0]
zdum=[0,0]
symcol=fltarr(starnum)
;
plot, xdum, ydum, psym=3, title='Stellar X-Y distribution', xrange=[min(x)-2, max(x)+2], $
	yrange=[min(y)-2, max(y)+2], xtitle='X-position (kpc)', ytitle='Y-position (kpc)', $
	xmargin=[8,6], ymargin=[6,8], charsize=1.25
loadct, 39
for i=0L, starnum-1 do begin
	symcol(i)=floor((sav(i)/max(sav))*255)
	oplot, [x(i),x(i)], [y(i),y(i)], thick=5, color=symcol(i)
endfor	
;
loadct,0
plot, xdum, zdum, psym=3, title='Stellar X-Z distribution', xrange=[min(x)-2, max(x)+2], $
	yrange=[min(y)-2, max(y)+2], xtitle='X-position (kpc)', ytitle='Z-position (kpc)', $
	xmargin=[8,6], ymargin=[6,8], charsize=1.25
loadct,39
for i=0L, starnum-1 do begin
	oplot, [x(i),x(i)], [z(i),z(i)], thick=5, color=symcol(i)
endfor	
cgcolorbar, divisions=floor(max(sav)), minor=3, range=[min(sav), max(sav)], $
	/right,  position=[0.1,0.925,0.9,0.95], charsize=1, title='SaV (mag.)', tlocation=bottom
print, min(sav)
device,/close
set_plot,'X'
;
;
end
