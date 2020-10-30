CREATE TABLE cities (
    city_name    VARCHAR2(40),
    population   NUMBER,
    shape     SDO_GEOMETRY
);

INSERT INTO cities VALUES (
    'Berlin',
    3769000,
    sdo_geometry(2001, 8307, sdo_point_type(13.404954, 52.520008, NULL), NULL, NULL) -- Long/Lat
);

INSERT INTO cities VALUES (
    'Offenbach',
    130280,
    sdo_geometry(2001, 8307, sdo_point_type(8.7760843, 50.0956362, NULL), NULL, NULL) -- Long/Lat
);

INSERT INTO cities VALUES (
    'Frankfurt/Main',
    763380,
    sdo_geometry(2001, 8307, sdo_point_type(8.684966, 50.110573, NULL), NULL, NULL) -- Long/Lat
);


INSERT INTO user_sdo_geom_metadata VALUES (
    'cities',
    'shape',
    sdo_dim_array(sdo_dim_element('Longitude', - 180, 180, 0.5), sdo_dim_element('Latitude', - 90, 90, 0.5)),
    8307
);