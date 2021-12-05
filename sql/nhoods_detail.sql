with crime_oct as(
    select id, date, primary_type, st_geogpoint(longitude, latitude) as geom
    from `musa-509-final.justtest.crime_2021-11-30`
    where date >='2021-10-01' and date < '2021-11-01'
    order by date
),
crime_nhood as (
    select N.pri_neigh, C.id, N.the_geom as neigh_geom, C.geom as crime_geom
    FROM `musa-509-final.justtest.neighborhood_2021-12-01` AS N
    cross join crime_oct as C
    where st_within(C.geom,N.the_geom)
),
crime_final as (
	select pri_neigh, count(id) as num_crime
	from crime_nhood
	group by pri_neigh
),
busstop as (
	select systemstop,st_geogpoint(point_x,point_y) as geom
	from `musa-509-final.justtest.bus_stop_2021-11-30`
),
check_bus as (
	SELECT N.pri_neigh,B.systemstop,N.the_geom as neigh_geom, B.geom as stop_geom
    from busstop as B
	cross join `musa-509-final.justtest.neighborhood_2021-12-01` AS N
    where st_within(B.geom,N.the_geom)
),
busstop_final as (
    select pri_neigh, count(systemstop) as num_busstop
	from check_bus
    group by pri_neigh
),
crime_bus as (
	select c.*, b.num_busstop
	from crime_final as c 
	join busstop_final as b 
	on c.pri_neigh = b.pri_neigh
),
grocery as (
	select store_name,st_geogpoint(longitude,latitude) as geom
	from `musa-509-final.justtest.grocery_2021-11-30`
),
check_grocery as (
	SELECT N.pri_neigh,G.store_name,N.the_geom as neigh_geom, G.geom as gro_geom
	FROM `musa-509-final.justtest.neighborhood_2021-12-01` AS N
	CROSS JOIN grocery as G
	where st_within(G.geom,N.the_geom)
),
grocery_final as (
	select pri_neigh, count(store_name) as num_grocery
	from check_grocery 
	group by pri_neigh
),
crime_bus_gro as (
	select c.*, 
    IfNULL(g.num_grocery, 0) as num_grocery
	from crime_bus as c 
	left join grocery_final as g 
	on c.pri_neigh = g.pri_neigh
),
restaurants as (
	SELECT DISTINCT dba_name,longitude,latitude
	FROM `musa-509-final.justtest.restaurant_2021-11-30` 
	WHERE facility_type = 'Restaurant' and longitude is not null and latitude is not null 
),
unique as (
	select dba_name,st_geogpoint(longitude,latitude) as geom
	from restaurants
),
check_res as (
	SELECT N.pri_neigh,R.dba_name,N.the_geom as neigh_geom, R.geom as res_geom
	FROM `musa-509-final.justtest.neighborhood_2021-12-01` AS N
	CROSS JOIN unique as R
	where st_within(R.geom,N.the_geom)
),
res_final as(
	select pri_neigh, count(dba_name) as num_res
	from check_res 
	group by pri_neigh
),
nhood_details as (
	select c.*, 
    IfNULL(r.num_res, 0) as num_restaurant
	from crime_bus_gro as c 
	left join res_final as r 
	on c.pri_neigh = r.pri_neigh
)
select * 
from nhood_details





