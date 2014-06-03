BEGIN;

create trigger update_time before update on timezone for each row execute procedure update_timestamp();
create trigger update_time before update on continent for each row execute procedure update_timestamp();
create trigger update_time before update on currency for each row execute procedure update_timestamp();
create trigger update_time before update on country for each row execute procedure update_timestamp();
create trigger update_time before update on state for each row execute procedure update_timestamp();
create trigger update_time before update on city for each row execute procedure update_timestamp();
create trigger update_time before update on postal_code for each row execute procedure update_timestamp();


-- Alter rail_subdivision_state

UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = s.abbreviation AND c.iso_alpha2 = 'US';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'AB' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'Alberta';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'BC' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'British Columbia';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'MB' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'Manitoba';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'NB' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'New Brunswick';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'NF' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'Newfoundland and Labrador';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'NS' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'Nova Scotia';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'NT' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'Northwest Territories';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'ON' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'Ontario';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'PQ' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'Quebec';
UPDATE rail_subdivision_state sub SET state = s.id FROM state s LEFT JOIN country c ON s.country = c.id WHERE sub.state = 'SK' AND c.iso_alpha2 = 'CA' AND s.name_ascii = 'Saskatchewan';


ALTER TABLE rail_subdivision_state ALTER COLUMN state SET DATA TYPE integer using (state::integer);
create index on rail_subdivision_state (state);
alter table rail_subdivision_state add foreign key (state) references state(id) on delete cascade;

COMMIT;
