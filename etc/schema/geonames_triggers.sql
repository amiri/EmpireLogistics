create trigger update_time before update on timezone for each row execute procedure update_timestamp();
create trigger update_time before update on continent for each row execute procedure update_timestamp();
create trigger update_time before update on currency for each row execute procedure update_timestamp();
create trigger update_time before update on country for each row execute procedure update_timestamp();
create trigger update_time before update on state for each row execute procedure update_timestamp();
create trigger update_time before update on city for each row execute procedure update_timestamp();
create trigger update_time before update on postal_code for each row execute procedure update_timestamp();
insert into object_type (name) values ('timezone'),( 'continent'),( 'currency'),( 'country'),( 'state'),( 'city'),( 'postal_code');
