create table test_table (
    id serial primary key,
    name varchar(100) not null,
    created_at timestamp default current_timestamp
);

insert into test_table (name)
values 
('Alice'), ('Bob'), ('Charlie');

select * from test_table;

select * from raw_data;