* How to make maps with Stata
* 1.8.2 Maps

* 1 STEP: Convert shapefile to .dta

	shp2dta using "$training_data/4_Data visualization/Map/gadm36_BGD_2.shp", data("$training_data/4_Data visualization/Map/BGD_zilamap") coor("$training_data/4_Data visualization/Map/BGD_zilacoor") replace genid(id)
	
	u "$training_data/4_Data visualization/Map/BGD_zilamap.dta", clear
	
	spmap using "$training_data/4_Data visualization/Map/BGD_zilacoor.dta" , id(id) 

* Mark unfeasible districts

	u "$training_data/4_Data visualization/Map/BGD_zilamap.dta", clear

	* 1.1 Mark Hill tract areas
	#delim ;
	g var = "Hill tract/Cox's" 
	if NAME_2 == "Chittagong" 
	| NAME_2 == "Khagrachhari" 
	| NAME_2 == "Rangamati" 
	| NAME_2 == "Bandarban" 
	| NAME_2 == "Cox'S Bazar"
	;
	#delim cr

	* 1.2 Mark Haor areas
	#delim ;
	replace var = "Haor areas" 
	if NAME_2 == "Sylhet" 
	| NAME_2 == "Maulvibazar" 
	| NAME_2 == "Habiganj" 
	| NAME_2 == "Sunamganj"
	;
	#delim cr

	* 1.3 Mark areas affected by Cyclones
	#delim ;
	replace var = "Cyclones" 
	if NAME_2 == "Khulna" 
	| NAME_2 == "Bagerhat" 
	| NAME_2 == "Pirojpur" 
	| NAME_2 == "Jhalokati"
	| NAME_2 == "Patuakhali"
	| NAME_2 == "Barguna"
	| NAME_2 == "Bhola"
	| NAME_2 == "Noakhali" 
	| NAME_2 == "Satkhira"  
	;
	#delim cr

	* 1.4 Mark areas affected by flooding
	#delim ;
	replace var = "Flooding" 
	if NAME_2 == "Faridpur" 
	| NAME_2 == "Sirajganj" 
	| NAME_2 == "Tangail" 
	| NAME_2 == "Jamalpur" 
	| NAME_2 == "Gaibandha" 
	| NAME_2 == "Lakshmipur" 
	;
	#delim cr

	* 1.5 Mark areas affected by water logging
	replace var = "Water Logging" if NAME_2 == "Jessore" 

	* 1.6 Mark areas affected by flash flood (if not already eliminated)
	replace var = "Flash flood" if NAME_2 == "Netrakona" 

	encode var, g(var2)
	
	preserve
	* Create labels
	u "$training_data/4_Data visualization/Map/BGD_zilacoor.dta", clear
	collapse (mean) _X _Y, by(_ID)
	rename _ID id
	merge 1:1 id using "$training_data/4_Data visualization/Map/BGD_zilamap.dta"
	keep id _X _Y NAME_2
	save "$training_data/4_Data visualization/Map/BGD_label_coor", replace
	restore
	
	* 1.7 Create map
	spmap var2 using "$training_data/4_Data visualization/Map/BGD_zilacoor.dta" , id(id) clmethod(unique)  ocolor(gs8 ..) fcolor(Pastel2) ndocolor(gs8 ..) name(base, replace) ndlab("Available districts") title({bf:Logistically unfeasible districts}) label(data("$training_data/4_Data visualization/Map/BGD_label_coor.dta") label(NAME_2) xcoord(_X) ycoord(_Y) length(20) size(*0.5) gap(*1) color(black)) legend(pos(7))

graph export "$training_output/Bangladesh_map.png", as(png) replace
