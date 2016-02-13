pro GRID_fileread, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, col1=col1, col2=col2, $
	mag_glob=mag_glob, hist_up=hist_up,hist_down=hist_down, hist_int=hist_int, $
	arr_app=arr_app, cutcount=cutcount, logg_q=logg_q, help=help
; 
; - - Procedure written to use read metallicity split star data filenames into required 
; - - file such that population synthesis may take place
;
;	NOTES:
;		- If log(g) specific runs being made, edit $outfilearr$ to distinguish restricted
;		  runs from global (~L52)
;		- Ensure filename consistency is retained between M_fileread.pro (~L52) and
;		  ../POST/mdf_plot.pro (~L90,105)for runs inducing multiple MDF plot
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
if (keyword_set(help) eq 1) then begin
   Message, 'Usage:',/info
   Message, 'GRID_fileread, arch_dir=arch_dir, sim1=sim1, sim2=sim2', /info
   Message, '	tag=tag, col1=col1,col2=col2, mag=mag, help=help', /info
   Message, 'Purpose: Read metallicity split simulation star selection filenames', /info
   Message, '         to population synthesis input file', /info
   Message, 'Input:   arch_dir = Directory source for SynCMD', /info
   Message, '	      sim1 = Simulation to be used (MUGS or MaGICC)', /info
   Message, '	      sim2 = Simulation iteration to be used (g1536 or g15784)', /info
   Message, '	      tag = SynCMD tag associated with analysis run', /info
   Message, '	      col1 = Colour #1 used within CMD analysis', /info
   Message, '	      col2 = Colour #2 used within CMD analysis', /info
   Message, '	      mag_glob = Magnitude scale used for CMD analysis', /info
   Message, 'Outputs: Star particle filename allocated to population', /info
   Message, '	      synthesis reference:', /info
   Message, '	      $arch_dir$/Code/Input_ListFilesNbodyStarParticles_Num_Loc.dat', /info
   return
endif
;
;		
	; - - - VARIABLE DEFINITIONS - - - ;
;
	hist_num_vec=abs((hist_up-hist_down)/hist_int)
	hist_num=hist_num_vec(0)
;
	dim1=['ofe','mgfe','feh']
	dim2=['feh','age','r']
	dim1point=[11,17,19]
	dim2point=[19,8,4]
;
	chem_gridup=1.
	chem_griddown=-2.
	chem_gridint=0.05
	chem_gridnum=60
;
	age_gridup=14
	age_griddown=0
	age_gridint=0.5
	age_gridnum=28
;
	r_gridup=15
	r_griddown=0
	r_gridint=0.5
	r_gridnum=30
;
	chem_bins=chem_gridnum
;
	dat_dir=arch_dir+'Outputs/PLOT_REF/'
	spawn, 'mkdir '+dat_dir
;
; - - -	MAIN PROGRAM - - - ;
;
;
for i=0L, n_elements(dim1)-1 do begin
;
; - - - Define the number of bins for dimension 2 (note that dimension 1 by construction is set as chem_bins)
;
	for j=0L, n_elements(dim2)-1 do begin
;
		if (dim1(i) eq dim2(j)) then continue
;
		case dim2(j) of
			'feh': begin
				dim2_down=chem_griddown
				dim2_int=chem_gridint
				dim2_bins=chem_gridnum
			       end
			'age': begin
				dim2_down=age_griddown
				dim2_int=age_gridint
				dim2_bins=age_gridnum
			       end
			'r': begin
				dim2_down=r_griddown
				dim2_int=r_gridint
				dim2_bins=r_gridnum
			     end 
		endcase
;
; - - - Define the number of input and output filenames are required fro each abundance analysis construct 
;
		for m=0L, chem_bins-1 do begin
			for n=0L, dim2_bins-1 do begin
				count=0
				case dim2(j) of
					'feh': begin
					       infilearr=strarr(chem_bins*chem_bins)
					       outfilearr=strarr(chem_bins*chem_bins)
					       end
					'age': begin
					       infilearr=strarr(age_gridnum*chem_gridnum)
					       outfilearr=strarr(age_gridnum*chem_gridnum)
					       end
					'r':   begin
					       infilearr=strarr(r_gridnum*chem_gridnum)
					       outfilearr=strarr(r_gridnum*chem_gridnum)
					       end
				endcase 
			endfor
		endfor
;
; - - - Define the SynCMD input and output filenames from grid_split.pro for each abundance
; - - - construct
; 
		for l=0, n_elements(infilearr)-1 do begin
			infilearr(l)=arch_dir+'Inputs/'+dim1(i)+'_'+dim2(j)+'/'+dim1(i)+'_'+ $
				dim2(j)+'_'+sim1+sim2+'_'+tag+'_'+strcompress(l+1, /remove_all)+'.dat'
			outfilearr(l)='../Outputs/'+dim1(i)+'_'+dim2(j)+'/'+col1+col2+ $
				'_'+mag_glob+'_'+dim1(i)+dim2(j)+'_'+sim1+sim2+'_'+tag+ $
				'_'+strcompress((l+1),/remove_all)
		endfor
;
; - - - Print the filename arrays into the appropriate SynCMD parameter files
; 
		filename=arch_dir+'Code/Input_ListFilesNbodyStarParticles_Num_Loc.dat'
		openw,lun,filename,/get_lun, width=35
		printf,lun, n_elements(infilearr)
		printf, lun, infilearr
		free_lun, lun
;
		filename=arch_dir+'Code/Ouput_NomefilesCMDgrilled.dat'
		openw,lun,filename,/get_lun
		printf,lun,n_elements(infilearr)
		printf,lun, outfilearr
		free_lun, lun
;
; - - - Run the SynCMD code iteratively to populated abundance bins appropriately with the synthetic population
;
		spawn, 'mkdir '+arch_dir+'Outputs/'+dim1(i)+'_'+dim2(j)+'/'
		print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
		print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
		print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
		print, 'The SynCMD code is now running for the analysis of: ', dim1(i), '   vs.   ', dim2(j)
		print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
		print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
		print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
		cd, arch_dir+'Code/'
		spawn, 'ifort nrtype.f90 nrutil.f90 Globals.f90 GRID_Grill.f90 Interpo.f90 Normale_S.f90 Bracket_age.f90 Bracket_col.f90 Bracket_mag.f90 Bracket_metal.f90 -o MDF_SynCMD.exe'
		spawn, './MDF_SynCMD.exe'
		cd, arch_dir+'Code/ANALYSES/MAIN/'
;
;
; - - - Read in CMD data for eath i'th and j'th dimension combination, and output abundance 
; - - - statistics per bin into appropriate filename for plotting
;
		gridlen=n_elements(infilearr)
		y_point=fltarr(chem_bins)
		x_point=fltarr(dim2_bins)
		grid_x=fltarr(gridlen)
		grid_y=fltarr(gridlen)
		totstar=fltarr(gridlen)
;
		for l=0L, gridlen-1 do begin
			filetag=strcompress(l+1,/remove_all)
			filein=arch_dir+'Outputs/'+dim1(i)+'_'+dim2(j)+'/'+col1+col2+ $
				'_'+mag_glob+'_'+dim1(i)+dim2(j)+'_'+sim1+sim2+'_'+tag+ $
				'_'+filetag+'_APP.dat'
;
			col=fltarr(arr_app)
			mag=fltarr(arr_app)
			nsynth=fltarr(arr_app)
			openr,lun,filein,/get_lun
;
			for m=0, arr_app-1 do begin
				readf, lun, tmp1, tmp2, tmp3
				nsynth(m)=tmp3
			endfor
;
			if (total(nsynth) eq 0) then totstar(l)=0
			totstar(l)=total(nsynth)
			free_lun, lun
;
; - - - Arrange grid data so that x and y pointers have the correct grid star number association 
;
			grid_y(l)=chem_griddown+((chem_gridint)*floor(float(l)/dim2_bins))+(chem_gridint/2.)
			grid_x(l)=dim2_down+((dim2_int)*(float(l)-(dim2_bins*floor(float(l)/dim2_bins))))+(dim2_int/2.)
;
		endfor
		print, 'The data for: ', dim1(i), ' vs. ', dim2(j), ' is now being printed in: ', dat_dir
		fileout=dat_dir+dim1(i)+'_'+dim2(j)+'_synth.dat'
		openw, lun, fileout, /get_lun
;
		for l=0, gridlen-1 do begin
			printf, lun, grid_x(l), grid_y(l), totstar(l)
		endfor
		free_lun, lun		
;
; - - - To ensure data capture is less that 5 GB, delete directory in which dim1(i) vs dim2(j) CMD
; - - - data is stored
;
		print, 'The ', dim1(i)+'_'+dim2(j)+' directory from /Outputs is now being cleansed'
		spawn,'rm -r '+arch_dir+'Outputs/'+dim1(i)+'_'+dim2(j)
;
; - - - close the j'th dimesion loop
	endfor
; - - - close the i'th dimension loop
endfor
;
; - - - Run a similar process, but for the unidimensional MDF analysis
;
dim1=['ofe','mgfe','feh','age']
dim1point=[11,17,19,8]
;
for c=0L, n_elements(dim1)-1 do begin
;
	if (dim1(c) eq 'age') then begin
		hist_num = (age_gridup - age_griddown)/age_gridint
	endif
;
	print, 'MDF for: ', dim1,' dimension'
	spawn, 'mkdir '+arch_dir+'Outputs/'+dim1(c)+'_mdf/'
	infilearr=strarr(hist_num)
	outfilearr=strarr(hist_num)
;
	for i=0, hist_num-1 do begin
		infilearr(i)='../Inputs/'+dim1(c)+'_mdf/'+dim1(c)+'_mdf_'+sim1+sim2+'_'+tag+ $
			'_'+strcompress((i+1),/remove_all)+'.dat'
		outfilearr(i)='../Outputs/'+dim1(c)+'_mdf/'+dim1(c)+'_mdf_'+col1+col2+'_'+ $
			mag_glob+'_MDFCMD'+sim1+sim2+'_'+tag+'_'+strcompress((i+1),/remove_all)
	endfor

	filename=arch_dir+'Code/Input_ListFilesNbodyStarParticles_Num_Loc.dat'
	openw,lun,filename,/get_lun, width=35
	printf,lun, hist_num
	printf, lun, infilearr
	free_lun, lun
;
	filename=arch_dir+'Code/Ouput_NomefilesCMDgrilled.dat'
	openw,lun,filename,/get_lun
	printf,lun,hist_num
	printf,lun, outfilearr
	free_lun, lun
;
; - - - Run the SynCMD process for the respective MDF analysis
;
	print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
	print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
	print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
	print, 'The SynCMD code is now running for the analysis of '+dim1(c)+' MDF data'
	print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
	print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
	print, '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
	cd, arch_dir+'Code/'
	spawn, 'ifort nrtype.f90 nrutil.f90 Globals.f90 GRID_Grill.f90 Interpo.f90 Normale_S.f90 Bracket_age.f90 Bracket_col.f90 Bracket_mag.f90 	Bracket_metal.f90 -o MDF_SynCMD.exe'
	spawn, './MDF_SynCMD.exe'
	cd, arch_dir+'Code/ANALYSES/MAIN/'
;
; - - - Compute the respective histogram (synthetic density), and print to file in directory defined by
; - - - dat_dir
;
	synhist_dat=fltarr(hist_num)
	stat_synthGLOBAL=fltarr(hist_num)
	hist_cent=fltarr(hist_num)
;
	for i=0, hist_num-1 do begin
		hist_cent(i)=hist_down(0)+(i*(hist_int(0)))+(0.5*hist_int(0))
		nsynth=fltarr(arr_app)
		filein=arch_dir+'Outputs/'+dim1(c)+'_mdf/'+dim1(c)+'_mdf_'+col1+col2+'_'+ $
			mag_glob+'_MDFCMD'+sim1+sim2+'_'+tag+'_'+strcompress((i+1),/remove_all)+'_APP.dat'
		openr,lun,filein,/get_lun
;
		for j=0L, arr_app-1 do begin
			readf, lun, tmp1, tmp2, tmp3
			nsynth(j)=tmp3	
		endfor
		synhist_dat(i)=total(nsynth)
		stat_synthGLOBAL(i)=synhist_dat(i)
		nsynth=0
	free_lun, lun
	endfor
;
	tot_synth=total(synhist_dat)
	print, tot_synth
	synhist_dat=synhist_dat/tot_synth	
;
	print, 'The data for the '+dim1(c)+' MDF is now being printed in: ', dat_dir
	fileout=dat_dir+dim1(c)+'_mdf_synth.dat'
;
	openw, lun, fileout, /get_lun
	for l=0L, hist_num-1 do begin
		printf, lun, hist_cent(l), synhist_dat(l)
	endfor
	free_lun, lun
;
; - - - If a multiple evolutionary analysis is taking place, the tag logg will output the MDF
; - - - characteristics as required.
;
	if  ((logg_q ne 0) AND (logg_q eq 1)) then begin
;
		synhistMS_dat=fltarr(hist_num)
		stat_synthMS=fltarr(hist_num)
		synhistSGP_dat=fltarr(hist_num)
		stat_synthSGP=fltarr(hist_num)
;
		for i=0, hist_num-1 do begin
			nsynth=fltarr(arr_app)
			filein=arch_dir+'Outputs/'+dim1(c)+'_mdf/'+dim1(c)+'_mdf_'+col1+col2+ $
				'_'+mag_glob+'_MDFCMD'+sim1+sim2+'_MS'+tag+'_'+ $
				strcompress((i+1),/remove_all)+'_APP.dat'
			openr,lun,filein,/get_lun
			for j=0L, arr_app-1 do begin
				readf, lun, tmp1, tmp2, tmp3
				nsynth(j)=tmp3
			endfor
			synhistMS_dat(i)=total(nsynth)
			stat_synthMS(i)=synhistMS_dat(i)
			nsynth=0
		free_lun, lun
		endfor
		print, 'MS+SG', total(stat_synthMS)
		synhistMS_dat=synhistMS_dat/tot_synth	
;
		print, 'The MS+SG data for the '+dim1(c)+' MDF is now being printed in: ', dat_dir
		fileout=dat_dir+dim1(c)+'_mdf_synthMS.dat'
		openw, lun, fileout, /get_lun
		for l=0, hist_num-1 do begin
			printf, lun, hist_cent(l), synhist_dat(l)
		endfor
		free_lun, lun	
;
		for i=0, hist_num(0)-1 do begin
			nsynth=dblarr(arr_app)
		filein=arch_dir+'Outputs/'+dim1(c)+'_mdf/'+dim1(c)+'_mdf_'+col1+col2+'_'+ $
			mag_glob+'_MDFCMD'+sim1+sim2+'_SGP'+tag+'_'+ $
			strcompress((i+1),/remove_all)+'_APP.dat'
		openr,lun,filein,/get_lun
			for j=0L, arr_app-1 do begin
				readf, lun, tmp1, tmp2, tmp3
				nsynth(j)=tmp3	
			endfor
			synhistSGP_dat(i)=total(nsynth)
			stat_synthSGP(i)=synhistSGP_dat(i)
			nsynth=0
		free_lun, lun
		endfor
		print, 'GB', total(stat_synthSGP)
		synhistSGP_dat=synhistSGP_dat/tot_synth	
;
		print, 'The GB data for the '+dim1(c)+' MDF is now being printed in: ', dat_dir
		fileout=dat_dir+dim1(c)+'_mdf_synthSGP.dat'
		openw, lun, fileout, /get_lun
		for l=0, hist_num-1 do begin
			printf, lun, hist_cent(l), synhist_dat(l)
		endfor
		free_lun, lun	
;
	endif
;
; - - - Carry out the same process for the simulation [Fe/H] distribution
;
	chem=fltarr(cutcount(0))
	age=fltarr(cutcount(0))
	filein=arch_dir+'Inputs/CMDSTARS'+sim1+sim2+'_'+tag+'.dat'
	openr,lun,filein,/get_lun
	for i=0L, cutcount(0)-1 do begin
		readf, lun, tmp1, tmp2, tmp3, tmp4, tmp5, tmp6, tmp7, tmp8, tmp9, tmp10, tmp11, tmp12, $
			tmp13, tmp14, tmp15, tmp16, tmp17, tmp18, tmp19, tmp20, tmp21, tmp22, tmp23, $
			tmp24,tmp25,tmp26
		age(i)=tmp9
;
		if (dim1(c) eq 'ofe') then begin
			chem(i)=tmp12
		endif
		if (dim1(c) eq 'mgfe') then begin
			chem(i)=tmp18
		endif
		if (dim1(c) eq 'feh') then begin
			chem(i)=tmp20
		endif
		if (dim1(c) eq 'age') then begin
			chem(i)=tmp9
		endif
;
	endfor
	free_lun, lun
;
; - - - Count the NORMALISED number of particles within a metallicity bin
;
	simhist_dat=fltarr(hist_num)
	stat_sim=fltarr(hist_num)
;
	print, cutcount(0)
	for i=0, hist_num-1 do begin
	  binpop=where((chem gt hist_down(0)+(hist_int(0)*i)) AND (chem lt hist_down(0)+(hist_int(0)*(i+1))))
	  simhist_dat(i)=n_elements(binpop)
	  stat_sim(i)=simhist_dat(i)
	  simhist_dat(i)=simhist_dat(i)/cutcount(0)
	endfor
;
	print, 'The simulation (composite) '+dim1(c)+' MDF is now being printed in: ', dat_dir
	fileout=dat_dir+dim1(c)+'_mdf_sim.dat'
	openw, lun, fileout, /get_lun
	for l=0, hist_num-1 do begin
		printf, lun, hist_cent(l), simhist_dat(l)
	endfor
	free_lun, lun	
;
; - - - Cleanse the respective directory system of all MDF data
;
	print, 'The feh_mdf directory from /Outputs is now being cleansed'
	spawn, 'rm -r '+arch_dir+'Outputs/'+dim1(c)+'_mdf'
endfor
;
;
end
