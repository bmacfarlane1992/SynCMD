pro grid_plot, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, hist_up=hist_up, $
	hist_down=hist_down, hist_int=hist_int, col1=col1, col2=col2, mag_glob=mag_glob, $
	logg_q=logg_q, stat_q=stat_q, help=help
;
;
	; - - - VARIABLE DEFINITIONS - - - ;
;
;
	dim1=['ofe','mgfe','feh']
	dim2=['feh','age','r']
	xtit=['[Fe/H] (dex)', 'Age (Gyr)', 'Galactocentric Radius (kpc)']
	ytit=['[O/Fe] (dex)', '[Mg/Fe] (dex)', '[Fe/H] (dex)']
	dat_dir=arch_dir+'Outputs/PLOT_REF/'
;
	chem_gridup=1.
	chem_griddown=-2.
;
	age_gridup=13
	age_griddown=0
;
	r_gridup=15
	r_griddown=0
;
	hist_num=(hist_up(0)-hist_down(0))/hist_int(0)
;
	plot_dir=arch_dir+'PLOTS/ABUNDANCES/'
	spawn, 'mkdir '+plot_dir
;
	cont_q=1
;
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;
; - - -	MAIN PROGRAM - - - ;
;
;
for i=0, n_elements(dim1)-1 do begin
;
	for j=0, n_elements(dim2)-1 do begin
;
		if (dim1(i) eq dim2(j)) then continue
;	
; - - - Define the ranges required for the abundance analysis plot
;
		case dim2(j) of 
			'feh':  begin
				xup=chem_gridup
				xdown=chem_griddown
				xdum=[chem_griddown, chem_griddown]
				ydum=[chem_griddown, chem_griddown]
				end
			'age':  begin
				xup=age_gridup
				xdown=age_griddown
				xdum=[age_griddown, age_griddown]
				ydum=[chem_griddown, chem_griddown]
				end
			'r':    begin
				xup=r_gridup
				xdown=r_griddown
				xdum=[r_griddown, r_griddown]
				ydum=[chem_griddown, chem_griddown]
				end
		endcase
		yup=chem_gridup
		ydown=chem_griddown
;
; - - - Read in the abundance relation file, and scale the color tag of each point to the total
; - - - number of synthetic stars
;
		!p.multi=0
		loadct, 39
		set_plot, 'ps'			
		filein=dat_dir+dim1(i)+'_'+dim2(j)+'_synth.dat'
		readcol, filein, x, y, stars, format=('D, D, D')
		stars=alog10(stars+1)

		if (cont_q eq 1) then begin
;
; - - - Begin triangulating data to plot abundance relation contour plot
;
				fileout=plot_dir+dim1(i)+'_'+dim2(j)+'_'+col1+col2+'_'+mag_glob+'_'+sim1+sim2+'_'+tag+'.eps'
				device,/encapsulated,file=fileout, xsize=12, ysize=12, /inches,/color
;	
				triangulate, x, y, tri
				grid=trigrid(x,y,stars,tri,missing=0,xgrid=xvector,ygrid=yvector, nx=10000, ny=10000)  
				levels=12
				step=(max(grid)-min(grid))/levels
				userlevels=indgen(levels)*step+min(grid)
				loadct, 5, ncolors=12, bottom=3
				contour,grid, xvector, yvector, yrange=[chem_griddown,chem_gridup], $
					/fill, position=[0.1,0.1,0.9,0.80], $
					levels=userlevels, C_Colors=IndGen(levels)+3, $
					xtitle=xtit(j), ytitle=ytit(i), ystyle=1, charsize=1.25, $
					xrange=[xdown,xup], xstyle=1
;
				cgColorbar, Divisions=floor(alog10(max(grid))), $
					Range=[Min(grid),Max(grid)], Format='(I4)', $
					Position=[0.88, 0.15, 0.9, 0.8], NColors=12, Bottom=3, $
					title=textoidl("Contour Legend (log_{10}(\nu))"),  $
					charsize=1.25
;
				device,/close
				set_plot,'X'
		endif
;
		if (cont_q ne 1) then begin
;
; - - - Plot scatter plot of abundance relations if contour plot query not fulfilled
;
			col_stars=fltarr(n_elements(stars))
			col_stars=floor((stars/max(stars))*250)
;
			!p.multi=0
			loadct, 0
			set_plot,'ps'
			fileout=plot_dir+dim1(i)+'_'+dim2(j)+'_'+col1+col2+'_'+mag_glob+'_'+sim1+sim2+'_'+tag+'.eps'
			device,/encapsulated,file=fileout, xsize=8, ysize=8, /inches,/color
;
			plot, xdum, ydum, xrange=[xdown, xup], yrange=[ydown, yup], xtitle=xtit(j), $
			ytitle=ytit(i), psym=3, xstyle=1, ystyle=1
			loadct, 39
			for l=0, n_elements(stars)-1 do begin
					if (stars(l) gt 0) then begin
						oplot, [x(l),x(l)], [y(l),y(l)], psym=symcat(16), symsize=1.5, $
						color=col_stars(l)	
					endif
			endfor
;	
			device,/close
			set_plot,'X'
		endif
;
	endfor
;
endfor
;
;
end

		

