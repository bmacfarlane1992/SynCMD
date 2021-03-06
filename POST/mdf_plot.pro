pro mdf_plot, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, hist_up=hist_up, $
	hist_down=hist_down, hist_int=hist_int, col1=col1, col2=col2, mag_glob=mag_glob, $
	synhist_dat=synhist_dat, simhist_dat=simhist_dat, stat_sim=stat_sim, stat_synthGLOBAL=stat_synthGLOBAL, $
	stats=stats, synhistMS_dat=synhistMS_dat, stat_synthMS=stat_synthMS, $
	synhistSGP_dat=synhistSGP_dat, stat_synthSGP=stat_synthSGP, logg_q=logg_q, stat_q=stat_q, help=help
;
; - - Procedure written to plot MDF comparison of spatially cut simulation stellar
; - - population, and the observationally selected synthetic population
;
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;
if (keyword_set(help) eq 1) then begin
   Message, 'Usage:',/info
   Message, 'grid_plot, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag,', /info
   Message, 'hist_up=hist_up, hist_down=hist_down, hist_int=hist_int,', /info
   Message, 'synhist_dat', /info
   Message, 'Purpose: Determine histogram values of simulation within ', /info
   Message, '         [Fe/H] range defined within premain.pro', /info
   Message, 'Input:   arch_dir = Directory in which SynCMD package stored', /info
   Message, '	      sim1 = Simulation used ([MaGICC, MUGS])', /info
   Message, '	      sim2 = Simulation iteration used ([g1536, g15784])', /info
   Message, '	      tag = SynCMD run tag association', /info
   Message, '	      hist_$i$ ($i$=[up, down, int]) = Histogram parameters to', /info
   Message, '	      to be utiltised within both simulation and synthetic analyses', /info
   Message, '	      col$i$ (i=[1,2]) = String tag associated with CMD', /info
   Message, '	      color selection', /info
   Message, '	      mag_glob = String tag associated with CMD magnitude selection', /info
   Message, '	      $i$hist_dat ($i$=[sim,synth]) = Histogram data for use in', /info
   Message, '	      comparison analyses', /info
   Message, '	      stat_$i$ ($i$ = [sim, synth]) = unnormalised histogram', /info
   Message, '	      data for use within statistic determination', /info
   Message, '	      stat_q = Query to determine whether moment() data is', /info
   Message, '	      stored within IDL .sav file.', /info
   Message, 'Outputs: Comparative MDF of both simulation and synthetic', /info
   Message, '	      stellar populations', /info
   Message, '	      stats = MDF statstics of both the simulation and', /info
   Message, '	      synthetic populations [mean, skewness, kurtosis]', /info
   return
endif
;
;
	; - - - VARIABLE DEFINITIONS - - - ;
;
;

;
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;
; - - -	MAIN PROGRAM - - - ;
;
;
	; - - - Plot the 
	; - - - whilst summing to determine constant of normalization by total.
;
hist_num=(hist_up(0)-hist_down(0))/hist_int(0)
hist_cent=fltarr(hist_num(0))
;
for i=0, hist_num(0)-1 do begin
	hist_cent(i)=hist_down(0)+(i*hist_int(0))+(hist_int(0)/2)	
endfor
;
max_y1=max(simhist_dat)
max_y2=max(synhist_dat)
;
!p.multi=0
loadct, 0
set_plot,'ps'
fileout=arch_dir+'/PLOTS/MDF/'+col1+col2+'_'+mag_glob+'_'+sim1+sim2+'_'+tag+'_MDF.eps'
device,/encapsulated,file=fileout, xsize=8, ysize=8, /inches,/color
;
if (max_y1 gt max_y2) then begin 
	plot, hist_cent, simhist_dat, psym=10, yrange=[0, max_y1+(0.1*max_y1)],	$
	xtitle='[Fe/H]', ytitle='Number ratio', xrange=[-3,1]
	oplot, hist_cent, synhist_dat, psym=10, linestyle=2
	meanings=['Composite particles', 'Synthetic population']
	linestyle=[0,2]
	al_legend,linestyle=linestyle,meanings,/left,/top
endif
;
if (max_y2 gt max_y1) then begin 
	plot, hist_cent, simhist_dat, psym=10, yrange=[0, max_y2+(0.1*max_y2)], $
	xtitle='[Fe/H]', ytitle='Number ratio', xrange=[-3,1]
	oplot, hist_cent, synhist_dat, psym=10, linestyle=2
	meanings=['Composite particles', 'Synthetic population']
	linestyle=[0,2]
	al_legend,linestyle=linestyle,meanings,/left,/top
endif
;
device,/close
set_plot,'X'
;
stats=fltarr(8)
;
;
if (stat_q eq 1) AND (stat_q ne 0) then begin
	stat_simfeh=fltarr(total(stat_sim))
	stat_count=0
	for i=0, hist_num(0)-1 do begin
		if (i eq 0) AND (stat_sim(i) ne 0) then begin 
			stat_simfeh(stat_count:stat_count+stat_sim(i)-1)=hist_cent(i)
			stat_count=stat_count+stat_sim(i)
		endif
;
		if (i ne 0) AND (i gt 0) AND (stat_sim(i) ne 0) then begin
			stat_simfeh(stat_count:stat_count+stat_sim(i)-1)=hist_cent(i)
			stat_count=stat_count+stat_sim(i)
		endif
;	
	endfor
;
;
	for i=0, hist_num(0)-1 do begin
		stat_synthGLOBAL(i)=floor(stat_synthGLOBAL(i))
	endfor
;
	if (total(stat_synthGLOBAL) gt 10000000) then begin
		stat_synfehUP=fltarr(total(stat_synthGLOBAL))
		help, stat_synfeh
			for i=0,hist_num(0)-1 do begin
				stat_synthGLOBAL(i)=stat_synthGLOBAL(i)/1000
			endfor
		for i=0, hist_num(0)-1 do begin
			if (i eq 0) AND (stat_synthGLOBAL(i) ne 0) then begin 
				stat_synfehUP(stat_count:stat_count+stat_synthGLOBAL(i)-1)=hist_cent(i)
				stat_count=stat_count+stat_synthGLOBAL(i)
			endif
;
			if (i ne 0) AND (i gt 0) AND (stat_synthGLOBAL(i) ne 0) then begin
				stat_synfehUP(stat_count:stat_count+stat_synthGLOBAL(i)-1)=hist_cent(i)
				stat_count=stat_count+stat_synthGLOBAL(i)
			endif
		endfor
;
	; - - - Slim the stat_synfeh array by removing any undefined values from stat_synfeh array
;	
	arrayfill=where(stat_synfehUP, count)
	count=count
	stat_synfeh=fltarr(count)
	stat_synfeh(*)=stat_synfehUP[arrayfill]
;
	endif
;
	if (total(stat_synthGLOBAL) lt 10000000) then begin
		stat_synfeh=fltarr(total(stat_synthGLOBAL))
		stat_count=0
		for i=0, hist_num(0)-1 do begin
			if (i eq 0) AND (stat_synthGLOBAL(i) ne 0) then begin 
				stat_synfeh(stat_count:stat_count+stat_synthGLOBAL(i)-1)=hist_cent(i)
				stat_count=stat_count+stat_synthGLOBAL(i)
			endif
;
			if (i ne 0) AND (i gt 0) AND (stat_synthGLOBAL(i) ne 0) then begin
				stat_synfeh(stat_count:stat_count+stat_synthGLOBAL(i)-1)=hist_cent(i)
				stat_count=stat_count+stat_synthGLOBAL(i)
			endif
		endfor
	endif
;
	stats(0:3)=moment(stat_simfeh)
	stats(4:7)=moment(stat_synfeh)
;
	print, "Simulation population statistics:"
	print, ""
	print, 'Mean: ', stats[0]
	print, 'Variance: ', stats[1]
	print, 'Skewness: ', stats[2]
	print, 'Kurtosis: ', stats[3]
	print, ""
	print, "Synthetic population statistics:"
	print, ""
	print, 'Mean: ', stats[4]
	print, 'Variance: ', stats[5]
	print, 'Skewness: ', stats[6]
	print, 'Kurtosis: ', stats[7]
;
	save, stats, filename=arch_dir+'PLOTS/MDF/'+col1+col2+'_'+mag_glob+'_'+sim1+sim2+'_'+tag+'STATS.sav'
;
endif
;
;
		; - - - Plot the MDF with logg restrictions as applied for MS, SG and G stars
;
if (logg_q ne 0) AND (logg_q eq 1) then begin
	!p.multi=0
	loadct, 13
	set_plot,'ps'
	fileout=arch_dir+'/PLOTS/MDF/'+col1+col2+'_'+mag_glob+'_'+sim1+sim2+'_'+tag+'_LOGGMDF.eps'
	device,/encapsulated,file=fileout, xsize=8, ysize=8, /inches,/color
;
	if (max_y1 gt max_y2) then begin 
		plot, hist_cent, simhist_dat, psym=10, yrange=[0, max_y1+(0.1*max_y1)],	$
		xtitle='[Fe/H]', ytitle='Number ratio', xrange=[-3,1], thick=10
		oplot, hist_cent, synhist_dat, psym=10, linestyle=0, thick=3
		oplot, hist_cent, synhistMS_dat, psym=10, linestyle=2, color=50, thick=3
		oplot, hist_cent, synhistSGP_dat, psym=10, linestyle=2, color=250, thick=3
		meanings=['Composite particles', 'Synthetic population', 'MS Population', 'SG + Giant Population']
		thick=[10,3,3,3]
		linestyle=[0,0,2,2]
		color=[0,0,50,250]
		al_legend,linestyle=linestyle,color=color,thick=thick,meanings,/left,/top
	endif
;
	if (max_y2 gt max_y1) then begin 
		plot, hist_cent, simhist_dat, psym=10, yrange=[0, max_y2+(0.1*max_y2)], $
		xtitle='[Fe/H]', ytitle='Number ratio', xrange=[-3,1], thick=10
		oplot, hist_cent, synhist_dat, psym=10, linestyle=0, thick=3
		oplot, hist_cent, synhistMS_dat, psym=10, linestyle=2, color=50, thick=3
		oplot, hist_cent, synhistSGP_dat, psym=10, linestyle=2, color=250, thick=3
		meanings=['Composite particles', 'Synthetic population', 'MS +SG Population', 'GB Population']
		thick=[10,3,3,3]
		linestyle=[0,0,2,2]
		color=[0,0,50,250]
		al_legend,linestyle=linestyle,color=color,thick=thick,meanings,/left,/top
	endif
	device,/close
	set_plot,'X'
;
	stats_pop=fltarr(8)
;
	stat_MSfeh=fltarr(total(stat_synthMS))
	stat_count=0
	for i=0, hist_num(0)-1 do begin
		if (i eq 0) AND (stat_synthMS(i) ne 0) then begin 
			stat_MSfeh(stat_count:stat_count+stat_synthMS(i)-1)=hist_cent(i)
			stat_count=stat_count+stat_synthMS(i)
		endif
		if (i ne 0) AND (i gt 0) AND (stat_synthMS(i) ne 0) then begin
			stat_MSfeh(stat_count:stat_count+stat_synthMS(i)-1)=hist_cent(i)
			stat_count=stat_count+stat_synthMS(i)
		endif
	endfor
;
	stat_SGPfeh=fltarr(total(stat_synthSGP))
	stat_count=0
	for i=0, hist_num(0)-1 do begin
		if (i eq 0) AND (stat_synthSGP(i) ne 0) then begin 
			stat_SGPfeh(stat_count:stat_count+stat_synthSGP(i)-1)=hist_cent(i)
			stat_count=stat_count+stat_synthSGP(i)
		endif
		if (i ne 0) AND (i gt 0) AND (stat_synthSGP(i) ne 0) then begin
			stat_SGPfeh(stat_count:stat_count+stat_synthSGP(i)-1)=hist_cent(i)
			stat_count=stat_count+stat_synthSGP(i)
		endif
;	
	endfor
	stats_pop(0:3)=moment(stat_MSfeh)
	stats_pop(4:7)=moment(stat_SGPfeh)
;
	print, "MS + SG population statistics:"
	print, ""
	print, 'Mean: ', stats_pop[0]
	print, 'Variance: ', stats_pop[1]
	print, 'Skewness: ', stats_pop[2]
	print, 'Kurtosis: ', stats_pop[3]
	print, ""
	print, "GB population statistics:"
	print, ""
	print, 'Mean: ', stats_pop[4]
	print, 'Variance: ', stats_pop[5]
	print, 'Skewness: ', stats_pop[6]
	print, 'Kurtosis: ', stats_pop[7]
	print, ""
;	
;
endif
;
;
;░░░░░░░░░▄░░░░░░░░░░░░░░▄░░░░ Much code...
;░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌░░░
;░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐░░░ 
;░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐░░░
;░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐░░░
;░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌░░░
;░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌░░ ... Such comment...
;░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐░░
;░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌░
;░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌░ ...Very regret...
;▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐░ 
;▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌
;▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐░
;░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌░
;░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐░░
;░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌░░ 
;░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀░░░
;░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀░░░░░ ...Wow
;░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▀▀░░░░░░░░
end
