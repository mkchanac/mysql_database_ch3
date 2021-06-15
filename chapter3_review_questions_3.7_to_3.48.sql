
-- Author: CMK Date: 15/6/2021 Textbook: Database Concepts 8th edition Pearson Chapter 3 Review Question 

-- 3.7
create table PET_OWNER(
	OwnerID int not null auto_increment,
    OwnerLastName varchar(35) not null,
    OwnerFirstName varchar(35) not null,
    OwnerPhone varchar(12) null,
    OwnerEmail varchar(100) not null,
    primary key(OwnerID) 
);
-- 3.8,3.9,3.10
create table PET(
	PetID int not null auto_increment,
    PetName varchar(50) not null,
    PetType varchar(50) not null,
    PetBreed varchar(15) null,
    PetDOB   date null,
    OwnerID int not null,
    primary key(PetID),
	foreign key(OwnerID) 
    references PET_OWNER(OwnerID)
    on delete cascade
);
ALTER TABLE PET_OWNER AUTO_INCREMENT=1;

insert into PET_OWNER (OwnerLastName,OwnerFirstName,OwnerPhone,OwnerEmail)
VALUES ('Downs','Marsha','555-537-8765','Marsha.Downs@somewhere.com'),
('James','Richard','555-537-7654','Richard.James@somewhere.com'),
('Frier','Liz','555-537-6543','Liz.Frier@somewhere.com'),
('Trent','Miles',null,'Miles.Trent@somewhere.com')
;

ALTER TABLE PET AUTO_INCREMENT=1;

insert into PET (PetName,PetType,PetBreed,PetDOB,OwnerID)
values ('King','Dog','Std. Poodle','2014/02/27',1),
('Teddy','Cat','Cashmere','2015/02/01',2),
('Fido','Dog','Std. Poodle','2013/07/17',1),
('AJ','Dog','Collie Mix','2014/05/05',3),
('Cedro','Cat','Unknown','2012/06/06',2),
('Wooley','Cat','Unknown',null,2),
('Buster','Dog','Border Collie','2011/12/11',4);

-- 3.13 
ALTER TABLE PET 
DROP CONSTRAINT OWNER_FK;
DROP TABLE PET_OWNER;
-- 3.14
ALTER TABLE PET 
DROP CONSTRAINT OWNER_FK;
DROP TABLE PET_OWNER;
-- 3.15 
SELECT OwnerID, OwnerLastName, OwnerFirstName, OwnerPhone, OwnerEmail FROM PET_OWNER;
-- 3.16
SELECT * FROM PET;
-- 3.17
SELECT PetBreed, PetType FROM PET;
SELECT DISTINCT PetBreed, PetType FROM PET;
-- 3.18
SELECT PetBreed, PetType,PetDOB FROM PET WHERE PetType = "Dog";
-- 3.19
SELECT PetBreed FROM PET;
-- 3.20
SELECT distinct PetBreed FROM PET;
-- 3.21
SELECT PetBreed, PetType, PetDOB from PET where PetType = "Dog" and PetBreed = "Std. Poodle";
-- 3.22
SELECT PetName, PetBreed, PetType from PET where PetType <> 'Dog' and PetType <> 'Cat' and PetType <> 'Fish';
-- 3.23
select PetID, PetBreed, PetType from PET where PetName like 'K___';
-- 3.24
select OwnerLastName, OwnerFirstName, OwnerEmail from PET_OWNER where OwnerEmail like '%somewhere.com';
-- 3.25
select OwnerLastName, OwnerFirstName, OwnerEmail from PET_OWNER where OwnerPhone is null;
-- 3.26
select PetName, PetBreed from PET order by PetName;
-- 3.27
select PetName, PetBreed from PET order by PetBreed asc,PetName desc;
-- 3.28
select count(*) from PET;
-- 3.29
select count(distinct PetBreed) from PET;
-- 3.30
create table PET_3(
	PetID int not null auto_increment,
    PetName varchar(50) not null,
    PetType varchar(50) not null,
    PetBreed varchar(15) null,
    PetDOB   date null,
    PetWeight	numeric(4,1) not null,
    OwnerID int not null,
    primary key(PetID),
	foreign key(OwnerID) 
    references PET_OWNER(OwnerID)
    on delete cascade
);

insert into PET_3 (PetName,PetType,PetBreed,PetDOB,PetWeight,OwnerID)
values ('King','Dog','Std. Poodle','2014/02/27',25.5,1),
('Teddy','Cat','Cashmere','2015/02/01',10.5,2),
('Fido','Dog','Std. Poodle','2013/07/17',28.5,1),
('AJ','Dog','Collie Mix','2014/05/05',20.0,3),
('Cedro','Cat','Unknown','2012/06/06',9.5,2),
('Wooley','Cat','Unknown',null,9.5,2),
('Buster','Dog','Border Collie','2011/12/11',25.0,4);

-- 3.31
select MIN(PetWeight) from PET_3;
select MAX(PetWeight) from PET_3; 
select avg(PetWeight) from PET_3;

-- 3.32
select PetBreed, avg(PetWeight) from PET_3 group by PetBreed;
-- 3.33
select PetBreed, avg(PetWeight) from PET_3 group by PetBreed having count(*) > 1;
-- 3.34
select PetBreed, avg(PetWeight) from PET_3 group by PetBreed having count(*) > 1 and PetBreed <> 'Unknown';
-- 3.35
select OwnerLastName, OwnerFirstName, OwnerEmail from PET_OWNER 
where OwnerID IN 
(select OwnerID from PET_3 where PetType = 'Cat');
-- 3.36
select OwnerLastName, OwnerFirstName, OwnerEmail from PET_OWNER 
where OwnerID IN 
(select OwnerID from PET_3 where PetName = 'Teddy');

-- 3.37
-- (1)
create table BREED (
	BreedName	varchar(15)		not null,
    MinWeight	numeric(4,1)	null,
    MaxWeight	numeric(4,1)	null,
    AverageLifeExpectancy	int	null,
    primary key(BreedName)
);
-- (2)
insert into BREED
values
('Border Collie',15.0,22.5,20),
('Cashmere', 10.0,15.0,12),
('Collie Mix', 17.5,25.0,18),
('Std. Poodle',22.5,30.0,18),
('Unknown',null,null,null);
-- (3)
alter table PET_3
add foreign key(PetBreed) references BREED(BreedName) on delete cascade on update cascade;
-- (4)
select OwnerLastName, OwnerFirstName, OwnerEmail from PET_OWNER
where OwnerID in 
(select OwnerID from PET_3 where PetBreed in 
(select BreedName from BREED where AverageLifeExpectancy>15)
);
-- 3.38
select o.OwnerLastName, o.OwnerFirstName, o.OwnerEmail from PET_OWNER o 
join PET_3 p on o.OwnerID = p.OwnerID
where p.PetType = 'Cat';
-- 3.39
select o.OwnerLastName, o.OwnerFirstName, o.OwnerEmail from PET_OWNER o 
join PET_3 p on o.OwnerID = p.OwnerID
where p.PetName = 'Teddy';
-- 3.40
select o.OwnerLastName, o.OwnerFirstName, o.OwnerEmail from PET_OWNER o 
join PET_3 p on o.OwnerID = p.OwnerID
join BREED b on p.PetBreed = b.BreedName 
where b.AverageLifeExpectancy > 15;
-- 3.41
select o.OwnerLastName, o.OwnerFirstName, p.PetName, p.PetType, p.PetBreed, b.AverageLifeExpectancy from PET_OWNER o
join PET_3 p on o.OwnerID = p.OwnerID
join BREED b on p.PetBreed = b.BreedName 
where p.PetBreed <> 'Unknown';
 -- 3.43
alter table PET_OWNER
modify OwnerEmail varchar(100) null;

insert into PET_OWNER (OwnerLastName,OwnerFirstName,OwnerPhone,OwnerEmail) 
values 
('Mayberry','Jenny','555-454-1243',null),
('Roberts','Ken','555-454-2354',null),
('Taylor','Sam','555-454-3465',null)
;
-- 3.44
alter table PET_3
drop foreign key pet_3_ibfk_2;
alter table PET_3
drop foreign key pet_3_ibfk_3;
alter table PET_3
add foreign key(PetBreed) references BREED(BreedName) on update cascade;

update BREED
set BreedName = 'Poodle, Std.'
where BreedName = 'Std. Poodle';

-- auto update the BreedName in PET_3.
-- 3.45
-- all the breedName, petType change to Poodle, Std.
-- 3.46
SET SQL_SAFE_UPDATES=1;
delete from PET_3 where PetType = 'Anteater';
-- 3.47
alter table PET add column PetWeight numeric(4,1) DEFAULT NULL;
-- 3.48
update PET
set PetWeight = CASE PetID 
                when 1 then 25.5
                when 2 then 10.5
                when 3 then 28.5
                when 4 then 20.0
                when 5 then 9.5
                when 6 then 9.5
                when 7 then 25.0
                end
where PetID between 1 and 7;
   