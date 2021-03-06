pro synth_hist, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag, hist_up=hist_up, $
hist_down=hist_down, hist_int=hist_int, col1=col1, col2=col2, mag_glob=mag_glob, $
synhist_dat, stat_synthGLOBAL, synhistMS_dat, stat_synthMS, synhistSGP_dat, stat_synthSGP, $
logg_q=logg_q, help=help
;
; - - Procedure written to determine histogram values within limits as determined within
; - - premain.pro, for synthetic population
;
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;
if (keyword_set(help) eq 1) then begin
   Message, 'Usage:',/info
   Message, 'synth_hist, arch_dir=arch_dir, sim1=sim1, sim2=sim2, tag=tag,', /info
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
   Message, '	      col$i$ ($i$=[1,2]) = String tag associated with CMD', /info
   Message, '	      color selection', /info
   Message, '	      mag_glob = String tag associated with CMD magnitude selection', /info
   Message, '	      logg_q = Input query as to output statistics of stellar ev.', /info
   Message, '	      binned MDF statistics.', /info
   Message, 'Outputs: synth_hist = Histogram data for use in', /info
   Message, '	      comparison analyses', /info
   Message, '	      stat_synthGLOBAL = unnormalised histogram data for use within', /info
   Message, '	      statistic determination', /info
   return
endif
;
;
	; - - - VARIABLE DEFINITIONS - - - ;
;
;
	mag_appup=30
	mag_appdown=-1
	col_appup=5
	col_appdown=-1
	grid_len=((mag_appup-mag_appdown)/0.05)*((col_appup-col_appdown)/0.05)
;
;
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
; = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
;
;
; - - -	MAIN PROGRAM - - - ;
;
;
	; - - - Calculate the total number of synthetic stars within metal split APP HRD
	; - - - whilst summing to determine constant of normalization by total.
;
hist_num=(hist_up(0)-hist_down(0))/hist_int(0)
synhist_dat=fltarr(hist_num(0))
stat_synthGLOBAL=fltarr(hist_num(0))
;
for i=0, hist_num(0)-1 do begin
	nsynth=fltarr(grid_len)
filein=arch_dir+'Outputs/feh_mdf/feh_mdf_'+col1+col2+'_'+mag_glob+'_MDFCMD'+sim1+sim2+'_'+tag+'_'+strcompress((i+1),/remove_all)+'_APP.dat'
openr,lun,filein,/get_lun
	for j=0L, grid_len-1 do begin
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
if  ((logg_q ne 0) AND (logg_q eq 1)) then begin
;
synhistMS_dat=fltarr(hist_num(0))
stat_synthMS=fltarr(hist_num(0))
synhistSGP_dat=fltarr(hist_num(0))
stat_synthSGP=fltarr(hist_num(0))
;
	for i=0, hist_num(0)-1 do begin
		nsynth=fltarr(grid_len)
	filein=arch_dir+'Outputs/CMDOut/MDF/'+col1+col2+'_'+mag_glob+'_MDFCMD'+sim1+sim2+'_MS'+tag+'_'+strcompress((i+1),/remove_all)+'_APP.dat'
	openr,lun,filein,/get_lun
		for j=0L, grid_len-1 do begin
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
	for i=0, hist_num(0)-1 do begin
		nsynth=dblarr(grid_len)
	filein=arch_dir+'Outputs/CMDOut/MDF/'+col1+col2+'_'+mag_glob+'_MDFCMD'+sim1+sim2+'_SGP'+tag+'_'+strcompress((i+1),/remove_all)+'_APP.dat'
	openr,lun,filein,/get_lun
		for j=0L, grid_len-1 do begin
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
;
endif
;
end

