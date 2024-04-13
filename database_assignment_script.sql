
create table if not exists public.chi_nhanh
(
    ma_chi_nhanh text not null unique,
    tinh character varying(40) collate pg_catalog."default",
    dia_chi character varying(40) collate pg_catalog."default",
    dien_thoai text,
    email character varying(40) collate pg_catalog."default",
    constraint chi_nhanh_pkey primary key (ma_chi_nhanh)
);



create table ha_chi_nhanh (
	ma_chi_nhanh text not null ,
	hinh_anh text ,
	primary key(ma_chi_nhanh, hinh_anh),
	unique(ma_chi_nhanh, hinh_anh),
	foreign key (ma_chi_nhanh)  references chi_nhanh(ma_chi_nhanh)
		on delete cascade
		on update cascade
);



create table khu (
    ma_chi_nhanh text not null  ,
    ten_khu text not null  ,
primary key(ma_chi_nhanh, ten_khu),

    foreign key (ma_chi_nhanh) references chi_nhanh (ma_chi_nhanh)
        on update cascade
        on delete cascade,
	unique(ma_chi_nhanh,ten_khu)
);

create table loai_phong (
    ma_loai_phong bigserial not null primary key ,
    ten_loai_phong text  not null,
	dien_tich int ,
	so_khach int check(so_khach >= 1 and so_khach <= 10),
	mo_ta_khac text 
);

create table thong_tin_giuong (
    ma_loai_phong bigint not null,
	kich_thuoc NUMERIC(10,1) not null,
	so_luong int default 1 check(so_luong  >= 1 and so_luong  <= 10) ,
	primary key (ma_loai_phong,kich_thuoc),
	foreign key (ma_loai_phong) references loai_phong(ma_loai_phong)
);

create table chi_nhanh_co_loai_phong (
    ma_loai_phong bigint not null,
	ma_chi_nhanh text not null,
	gia_thue int not null ,
	primary key (ma_loai_phong,ma_chi_nhanh),
	foreign key (ma_loai_phong) references loai_phong(ma_loai_phong),
	foreign key (ma_chi_nhanh) references chi_nhanh(ma_chi_nhanh)
);

create table phong (
    ma_loai_phong bigint not null,
	ma_chi_nhanh text not null ,
	so_phong varchar(3) not null ,
	ten_khu text not null ,
	primary key (so_phong,ma_chi_nhanh),
	foreign key (ma_loai_phong) references loai_phong(ma_loai_phong),
	foreign key (ma_chi_nhanh) references chi_nhanh(ma_chi_nhanh),
	foreign key (ma_chi_nhanh,ten_khu) references khu(ma_chi_nhanh,ten_khu)
);

create table loai_vat_tu
(
    ma_loai_vat_tu varchar(6) not null primary key,
    ten_loai_vat_tu text not null
);

create table public.loai_vat_tu_trong_phong
(
    ma_loai_vat_tu varchar(6) not null,
    ma_loai_phong bigint not null,
    so_luong int not null default 1 check(so_luong  >= 1 and so_luong  <= 20),
    primary key (ma_loai_vat_tu, ma_loai_phong),
    foreign key (ma_loai_vat_tu)
        references public.loai_vat_tu (ma_loai_vat_tu) match simple
        on update cascade
        on delete cascade
        not valid,
    foreign key (ma_loai_phong)
        references public.loai_phong (ma_loai_phong) match simple
        on update cascade
        on delete cascade
        not valid
);
create table public."vat_tu"
(
    "ma_chi_nhanh" text,
    "ma_loai_vat_tu" varchar(6),
    "stt_vat_tu" integer check (stt_vat_tu >=1) ,
    tinh_trang character varying(255),
    so_phong varchar(3),
    primary key ("ma_chi_nhanh", "ma_loai_vat_tu", "stt_vat_tu"),
    foreign key ("ma_chi_nhanh")
        references public.chi_nhanh (ma_chi_nhanh) match simple
        on update cascade
        on delete cascade
        not valid,
    foreign key ("ma_loai_vat_tu")
        references public.loai_vat_tu (ma_loai_vat_tu) match simple
        on update cascade
        on delete cascade
        not valid,
    foreign key ("ma_chi_nhanh", so_phong)
        references public.phong (ma_chi_nhanh, so_phong) match simple
        on update cascade
        on delete cascade
        not valid
);


create table public."nha_cung_cap"
(
    "ma_nha_cung_cap" varchar(7),
    "ten_nha_cung_cap" text,
     email text,
    "dia_chi" text,
    primary key ("ma_nha_cung_cap")
);

alter table if exists public."nha_cung_cap"
    owner to postgres;

create table public."cung_cap_vat_tu"
(
    "ma_nha_cung_cap" varchar(7),
    "ma_loai_vat_tu" varchar(6),
    "ma_chi_nhanh" text,
    primary key ("ma_loai_vat_tu", "ma_chi_nhanh"),
    foreign key ("ma_nha_cung_cap")
        references public."nha_cung_cap" ("ma_nha_cung_cap") match simple
        on update cascade
        on delete cascade
        not valid,
    foreign key ("ma_loai_vat_tu")
        references public.loai_vat_tu (ma_loai_vat_tu) match simple
        on update cascade
        on delete cascade
        not valid,
    foreign key ("ma_chi_nhanh")
        references public.chi_nhanh (ma_chi_nhanh) match simple
        on update cascade
        on delete cascade
        not valid
);




create table public."khach_hang"
(
    "ma_khach_hang" varchar(8),
    "cccd/cmnd" character varying(12) not null Unique ,
     "ho_ten" text,
    "dien_thoai" text not null Unique ,
    "email" text Unique ,
    "username" text Unique,
    "password" text Unique,
    "diem" integer not null default 0 check (diem >= 0),
    "loai" integer not null default 1 check(loai >= 1),
    primary key ("ma_khach_hang")
);

alter table if exists public."khach_hang"
    owner to postgres;

create table public."goi_dich_vu"
(
    "so_ngay" integer not null check (so_ngay >= 1 and so_ngay <=100) ,
    "so_khach" integer not null check (so_khach >= 1 and so_khach <=10),
    "gia" integer not null,
    "ten_goi" text,
    primary key ("ten_goi")
);

alter table if exists public."goi_dich_vu"
    owner to postgres;


create table public."hoa_don_goi_dich_vu"
(
    "ma_khach_hang" varchar(8),
    "ten_goi" text,
    "ngay_gio_mua" timestamp  ,
    "ngay_bat_dau" date check ( ngay_bat_dau > ngay_gio_mua ) ,
    "tong_tien" real not null,
ngay_con_lai integer DEFAULT 0,
    primary key ("ma_khach_hang", "ten_goi", "ngay_gio_mua"),
    foreign key ("ma_khach_hang")
        references public."khach_hang" ("ma_khach_hang") match simple
        on update cascade
        on delete cascade
        not valid,
    foreign key ("ten_goi")
        references public."goi_dich_vu" ("ten_goi") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."hoa_don_goi_dich_vu"
    owner to postgres;

create table public."don_dat_phong"
(
    "ma_dat_phong" character varying(16),
    "ngay_gio_dat" timestamp without time zone,
    "so_khach" integer,
    "ngay_nhan_phong" date check ( ngay_nhan_phong > ngay_gio_dat) ,
    "ngay_tra_phong" date check( ngay_tra_phong > ngay_nhan_phong) ,
    "tinh_trang" smallint,
    "tong_tien" real not null default 0,
    "ma_khach_hang" varchar(8),
    "ten_goi_dich_vu" text default null ,
    primary key ("ma_dat_phong"),
    foreign key ("ma_khach_hang")
        references public."khach_hang" ("ma_khach_hang") match simple
        on update cascade
        on delete cascade
        not valid,
    foreign key ("ten_goi_dich_vu")
        references public."goi_dich_vu" ("ten_goi") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."don_dat_phong"
    owner to postgres;


create table public."phong_thue"
(
    "ma_dat_phong" character varying(16),
    "ma_chi_nhanh" text,
    "so_phong" varchar(3),
    primary key ("ma_dat_phong", "ma_chi_nhanh", "so_phong"),
    foreign key ("ma_dat_phong")
        references public."don_dat_phong" ("ma_dat_phong") match simple
        on update cascade
        on delete cascade
        not valid,
    foreign key ("ma_chi_nhanh", "so_phong")
        references public.phong (ma_chi_nhanh, so_phong) match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."phong_thue"
    owner to postgres;



create table public."hoa_don"
(
    "ma_hoa_don" character varying(16),
    "thoi_gian_nhan_phong" time without time zone,
    "thoi_gian_tra_phong" time without time zone,
    "ma_dat_phong" character varying(16),
    primary key ("ma_hoa_don"),
    foreign key ("ma_dat_phong")
        references public."don_dat_phong" ("ma_dat_phong") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."hoa_don"
    owner to postgres;


create table public."doanh_nghiep"
(
    "ma_doanh_nghiep" character varying(6),
    "ten_doanh_nghiep" text,
    primary key ("ma_doanh_nghiep")
);

alter table if exists public."doanh_nghiep"
    owner to postgres;



create table public."dich_vu"
(
    "ma_dich_vu" character varying(6),
    "loai_dich_vu" text,
    "so_khach" integer,
    "phong_cach" text,
    "ma_doanh_nghiep" text,
    primary key ("ma_dich_vu"),
    foreign key ("ma_doanh_nghiep")
        references public."doanh_nghiep" ("ma_doanh_nghiep") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."dich_vu"
    owner to postgres;


create table public."dich_vu_spa"
(
    "ma_dich_vu" character varying(6),
    "dich_vu_spa" text,
    primary key ("ma_dich_vu", "dich_vu_spa"),
    foreign key ("ma_dich_vu")
        references public."dich_vu" ("ma_dich_vu") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."dich_vu_spa"
    owner to postgres;


create table public."loai_hang_do_luu_niem"
(
    "ma_dich_vu" character varying(6),
    "loai_hang" text,
    primary key ("ma_dich_vu", "loai_hang"),
    foreign key ("ma_dich_vu")
        references public."dich_vu" ("ma_dich_vu") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."loai_hang_do_luu_niem"
    owner to postgres;


create table public."thuong_hieu_do_luu_niem"
(
    "ma_dich_vu" character varying(6),
    "thuong_hieu" text,
    primary key ("ma_dich_vu", "thuong_hieu"),
    foreign key ("ma_dich_vu")
        references public."dich_vu" ("ma_dich_vu") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."thuong_hieu_do_luu_niem"
    owner to postgres;


create table public."mat_bang"
(
    "ma_chi_nhanh" text,
    "stt_mat_bang" integer not null default 1 check (stt_mat_bang >=1 and stt_mat_bang <= 50),
    "chieu_dai" integer,
    "chieu_rong" integer,
    "gia_thue" integer not null,
    "mo_ta" text,
    "ma_dich_vu" text,
    "ten_cua_hang" text,
    "logo" text,
    primary key ("ma_chi_nhanh", "stt_mat_bang"),
    foreign key ("ma_chi_nhanh")
        references public.chi_nhanh (ma_chi_nhanh) match simple
        on update cascade
        on delete cascade
        not valid,
    foreign key ("ma_dich_vu")
        references public."dich_vu" ("ma_dich_vu") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."mat_bang"
    owner to postgres;


create table public."hinh_anh_cua_hang"
(
    "ma_chi_nhanh" text,
    "stt_mat_bang" integer,
    "hinh_anh" text,
    primary key ("ma_chi_nhanh", "stt_mat_bang"),
    foreign key ("ma_chi_nhanh", "stt_mat_bang")
        references public."mat_bang" ("ma_chi_nhanh", "stt_mat_bang") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."hinh_anh_cua_hang"
    owner to postgres;

create table public."khung_gio_hoat_dong_cua_hang"
(
    "ma_chi_nhanh" text,
    "stt_mat_bang" integer,
    "gio_bat_dau" time without time zone,
    "gio_ket_thuc" time without time zone,
    primary key ("ma_chi_nhanh", "stt_mat_bang", "gio_bat_dau"),
    foreign key ("ma_chi_nhanh", "stt_mat_bang")
        references public."mat_bang" ("ma_chi_nhanh", "stt_mat_bang") match simple
        on update cascade
        on delete cascade
        not valid
);

alter table if exists public."khung_gio_hoat_dong_cua_hang"
    owner to postgres;



CREATE OR REPLACE FUNCTION public.tong_tien_goi_dich_vu()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare 
	giam_gia int;
	tien_goi int;
	loai_khach int;
	BEGIN
		select k.loai into loai_khach from khach_hang k  where NEW.ma_khach_hang = k.ma_khach_hang;
		if (loai_khach =3) then
			giam_gia = 85 ;
			update hoa_don_goi_dich_vu h  set ngay_con_lai = ngay_con_lai +1;
		elseif (loai_khach =4) then
			giam_gia = 80;
			update hoa_don_goi_dich_vu h  set ngay_con_lai = ngay_con_lai +2;
		else 
			giam_gia = 100;
		end if;
		
		
		select gia into tien_goi from goi_dich_vu g
				where NEW.ten_goi = g.ten_goi ;  
		
			 new.tong_tien =   tien_goi * giam_gia /100 ;
		--	end if;
			RETURN NEW;
	END;
$BODY$;


CREATE TRIGGER trigg_tong_tien_goi_dich_vu
    BEFORE INSERT on hoa_don_goi_dich_vu 
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tong_tien_goi_dich_vu();





-- FUNCTION: public.tong_tien_don_dat_phong()

-- DROP FUNCTION IF EXISTS public.tong_tien_don_dat_phong();

CREATE OR REPLACE FUNCTION public.tong_tien_don_dat_phong()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare 
	giam_gia int;
	tien_phong int;
	loai_khach int;
	ngay_thue int;
	goi_dv text;
	BEGIN
	select k.loai into loai_khach from khach_hang k , don_dat_phong d  where NEW.ma_dat_phong = d.ma_dat_phong
															AND d.ma_khach_hang = k.ma_khach_hang ;
		if (loai_khach =2) then
			giam_gia := 90;
		elseif (loai_khach =3) then
			giam_gia := 85 ;
		elseif (loai_khach =4) then
			giam_gia := 80;
		else giam_gia := 100;
		end if;
		
		select abs(extract('day' from d.ngay_tra_phong::timestamp - d.ngay_nhan_phong::timestamp)) into ngay_thue from don_dat_phong d where new.ma_dat_phong = d.ma_dat_phong;
		select gia_thue into tien_phong from chi_nhanh_co_loai_phong cn
				where NEW.ma_chi_nhanh = cn.ma_chi_nhanh   and
						cn.ma_loai_phong = (SELECT ma_loai_phong from phong p
																 where p.so_phong = NEW.so_phong AND 
																 		p.ma_chi_nhanh = NEW.ma_chi_nhanh);
		select d.ten_goi_dich_vu into goi_dv from don_dat_phong d where new.ma_dat_phong =d.ma_dat_phong	;	
		if (goi_dv <> null) then
			UPDATE don_dat_phong d SET tong_tien = tong_tien where d.ma_dat_phong = new.ma_dat_phong;
		else
			UPDATE don_dat_phong d SET tong_tien =  tong_tien + tien_phong* ngay_thue * giam_gia /100 where d.ma_dat_phong = new.ma_dat_phong;
		end if;
			RETURN NEW;
	END;
$BODY$;






CREATE TRIGGER trigg_tong_tien_don_dat_phong
    BEFORE INSERT on phong_thue
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tong_tien_don_dat_phong();






CREATE OR REPLACE FUNCTION public.diem_khach_hang_goi_dich_vu()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare 
	
	tien_tra_goi_dich_vu int;
	
	BEGIN
	select new.tong_tien into tien_tra_goi_dich_vu 
			from hoa_don_goi_dich_vu h, khach_hang k 
			where k.ma_khach_hang = h.ma_khach_hang
			and  new.ten_goi = h.ten_goi
			and new.ngay_gio_mua = h.ngay_gio_mua
			and new.ma_khach_hang = h.ma_khach_hang;
	
			
	update khach_hang k set diem = diem + tien_tra_goi_dich_vu / 1000 
		
			where new.ma_khach_hang = k.ma_khach_hang;
			
	RETURN new;		
	END;
$BODY$;

ALTER FUNCTION public.diem_khach_hang_goi_dich_vu()
    OWNER TO postgres;







CREATE TRIGGER trigg_diem_khach_hang_goi_dich_vu
    AFTER INSERT on hoa_don_goi_dich_vu
	FOR EACH ROW  
    EXECUTE FUNCTION public.diem_khach_hang_goi_dich_vu();








CREATE OR REPLACE FUNCTION public.diem_khach_hang_don_dat_phong()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare 
	giam_gia int;
	tien_phong int;
	loai_khach int;
	goi_dv text;
	tien_tra_don_dat_phong int;
	ngay_thue int;
	BEGIN
	select k.loai into loai_khach from khach_hang k , don_dat_phong d  where NEW.ma_dat_phong = d.ma_dat_phong
															AND d.ma_khach_hang = k.ma_khach_hang ;
			
		if (loai_khach =2) then
			giam_gia := 0.9;
		elseif (loai_khach =3) then
			giam_gia := 0.85 ;
		elseif (loai_khach =4) then
			giam_gia := 0.80;
		else giam_gia := 1;
		end if;
		
		select gia_thue into tien_phong from chi_nhanh_co_loai_phong cn
				where NEW.ma_chi_nhanh = cn.ma_chi_nhanh   and
						cn.ma_loai_phong = (SELECT ma_loai_phong from phong p
																 where p.so_phong = NEW.so_phong AND 
																 		p.ma_chi_nhanh = NEW.ma_chi_nhanh);
			
	select abs(extract('day' from d.ngay_tra_phong::timestamp - d.ngay_nhan_phong::timestamp)) into ngay_thue from don_dat_phong d where new.ma_dat_phong = d.ma_dat_phong;		
	update khach_hang k set diem = diem + tien_phong * giam_gia * ngay_thue / 1000 
			from don_dat_phong d 
			where d.tinh_trang = 1
				and k.ma_khach_hang = (select d.ma_khach_hang from don_dat_phong d where new.ma_dat_phong = d.ma_dat_phong) ;
		return new;	
	END;
$BODY$;








CREATE TRIGGER trigg_diem_khach_hang_don_dat_phong
    BEFORE INSERT on phong_thue
	FOR EACH ROW   
    EXECUTE FUNCTION public.diem_khach_hang_don_dat_phong();











CREATE OR REPLACE FUNCTION public.loai_khach_hang()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare 

	diem_khach int;
	loai_khach int;
	
	BEGIN
	
	NEW.loai := CASE WHEN NEW.diem < 50 THEN 1 
                    WHEN NEW.diem BETWEEN 50 AND 100 THEN 2 
					WHEN NEW.diem BETWEEN 100 AND 1000 THEN 3 
                    ELSE 4 END;
	
			
	RETURN NEW;	
	
	END;
$BODY$;

ALTER FUNCTION public.loai_khach_hang()
    OWNER TO postgres;


CREATE TRIGGER trigg_cap_nhat_loai_khach_hang
    before INSERT or UPDATE on khach_hang
	FOR EACH ROW  
    EXECUTE FUNCTION public.loai_khach_hang();





CREATE OR REPLACE FUNCTION public.kiem_tra_goi_dich_vu()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
declare 
	han_goi_cu date;
	BEGIN
	
	select (h.ngay_bat_dau + interval '1 year')::date into  han_goi_cu from hoa_don_goi_dich_vu h
														where new.ma_khach_hang = h.ma_khach_hang
														and new.ten_goi = h.ten_goi;
	
	if (new.ngay_bat_dau < han_goi_cu) then
		raise  EXCEPTION 'Goi dich vu con thoi gian hieu luc, khong the mua goi moi. Quy khach hay thay doi Ngay bat dau cua Goi dich vu moi';
		end if;
	
	
	
	
			RETURN NEW;
	END;
$BODY$;

ALTER FUNCTION public.kiem_tra_goi_dich_vu()
    OWNER TO postgres;
	
	CREATE TRIGGER trigg_kiem_tra_goi_dich_vu
    before INSERT  on hoa_don_goi_dich_vu
	FOR EACH ROW  
    EXECUTE FUNCTION public.kiem_tra_goi_dich_vu();





create or replace function public.GoiDichVu(
	ma character)
    returns table ( ten_goi text,
				   so_khach integer ,
				  ngay_bat_dau date,
				   ngay_het_han date,			
				   so_ngay_con_lai double precision
				  )
    language 'plpgsql'
    cost 100
    volatile parallel unsafe
    rows 1000

as $body$
declare
	ngay_het_han date ;
	con_lai date;

begin
		
 	return query
	select 
		h.ten_goi, 
		g.so_khach, 
		h.ngay_bat_dau,
		(h.ngay_bat_dau + interval '1 year') :: date,
		date_part('day', h.ngay_bat_dau + interval '1 year' - current_date)			
	from
		hoa_don_goi_dich_vu h ,
		goi_dich_vu g
	where
		ma = h.ma_khach_hang and
		h.ten_goi = g.ten_goi;
	

end;
$body$;


CREATE OR REPLACE FUNCTION public.ThongKeLuotKhach(
	ma_cn text,
	nam integer)
    RETURNS TABLE(thang integer, tong_so_khach bigint) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
	return query
	select
		extract (month FROM d.ngay_nhan_phong)::int as Thang,
    	sum(d.so_khach) as So_khach        
	FROM don_dat_phong d
			
		
	where EXTRACT(YEAR FROM d.ngay_gio_dat)::int = nam 
		and d.tinh_trang = 1 
		--and d.ma_dat_phong = (select ma_dat_phong from phong_thue ph where ma_cn = ph.ma_chi_nhanh)
		and true =  exists (SELECT 1 FROM phong_thue p WHERE  p.ma_dat_phong =d.ma_dat_phong and  p.ma_chi_nhanh = ma_cn LIMIT 1)
		--and p.ma_chi_nhanh = ma_cn
		--and p.ma_dat_phong =d.ma_dat_phong
	GROUP BY extract (month FROM d.ngay_nhan_phong)
	;
	
end;
$BODY$;

	

CREATE SEQUENCE sequence_1
start with 1
increment by 1
minvalue 0
maxvalue 1000
cycle;

-- FUNCTION: public.tao_ma_chi_nhanh()

-- DROP FUNCTION IF EXISTS public.tao_ma_chi_nhanh();

CREATE OR REPLACE FUNCTION public.tao_ma_chi_nhanh()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
			
			UPDATE chi_nhanh SET ma_chi_nhanh =  ma_chi_nhanh || CAST(nextval('sequence_1') AS TEXT) where ma_chi_nhanh = 'CN' ;
		--	end if;
			RETURN NEW;
	END;
$BODY$;

ALTER FUNCTION public.tao_ma_chi_nhanh()
    OWNER TO postgres;




CREATE TRIGGER trigg_tao_ma_chi_nhanh
    AFTER INSERT on chi_nhanh
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tao_ma_chi_nhanh();


CREATE SEQUENCE sequence_loai_vat_tu
start with 1
increment by 1
minvalue 0
maxvalue 1000
cycle;


-- FUNCTION: public.tao_ma_nha_cung_cap()

-- DROP FUNCTION IF EXISTS public.tao_ma_nha_cung_cap();

CREATE OR REPLACE FUNCTION public.tao_ma_loai_vat_tu()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
			
			UPDATE loai_vat_tu SET ma_loai_vat_tu =  ma_loai_vat_tu || LPAD( CAST(nextval('sequence_loai_vat_tu') AS varchar(4)) ,4, '0' )  where ma_loai_vat_tu = 'VT' ;
		--	end if;
			RETURN NEW;
	END;
$BODY$;







CREATE TRIGGER trigg_tao_ma_loai_vat_tu
    AFTER INSERT on loai_vat_tu
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tao_ma_loai_vat_tu();





CREATE SEQUENCE sequence_nha_cung_cap
start with 1
increment by 1
minvalue 0
maxvalue 1000
cycle;


-- FUNCTION: public.tao_ma_nha_cung_cap()

-- DROP FUNCTION IF EXISTS public.tao_ma_nha_cung_cap();

CREATE OR REPLACE FUNCTION public.tao_ma_nha_cung_cap()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
			
			UPDATE nha_cung_cap SET ma_nha_cung_cap =  ma_nha_cung_cap || LPAD( CAST(nextval('sequence_nha_cung_cap') AS varchar(7)) ,4, '0' )  where ma_nha_cung_cap = 'NCC' ;
		--	end if;
			RETURN NEW;
	END;
$BODY$;

ALTER FUNCTION public.tao_ma_nha_cung_cap()
    OWNER TO postgres;






CREATE TRIGGER trigg_tao_ma_nha_cung_cap
    AFTER INSERT on nha_cung_cap
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tao_ma_nha_cung_cap();










CREATE SEQUENCE sequence_khach_hang	
start with 1
increment by 1
minvalue 0
maxvalue 1000
cycle;

CREATE OR REPLACE FUNCTION public.tao_ma_khach_hang()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
			
			UPDATE khach_hang SET ma_khach_hang =  ma_khach_hang ||LPAD( CAST(nextval('sequence_khach_hang') AS varchar(8)) ,6, '0' ) where ma_khach_hang = 'KH' ;
		--	end if;
			RETURN NEW;
	END;
$BODY$;



CREATE TRIGGER trigg_tao_ma_khach_hang
    AFTER INSERT on khach_hang
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tao_ma_khach_hang();









CREATE SEQUENCE sequence_don_dat_phong	
start with 1
increment by 1
minvalue 0
maxvalue 1000
cycle;

-- FUNCTION: public.tao_ma_dat_phong()

-- DROP FUNCTION IF EXISTS public.tao_ma_dat_phong();

CREATE OR REPLACE FUNCTION public.tao_ma_dat_phong()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
			
			UPDATE don_dat_phong SET ma_dat_phong = ma_dat_phong ||to_char(ngay_gio_dat, 'DDMMYYYY')  ||LPAD( CAST(nextval('sequence_don_dat_phong') AS varchar(8)) ,6, '0' ) where ma_dat_phong = 'DP' ;
		--	end if;
			RETURN NEW;
	END;
$BODY$;

ALTER FUNCTION public.tao_ma_dat_phong()
    OWNER TO postgres;




CREATE TRIGGER trigg_tao_ma_dat_phong
    AFTER INSERT on don_dat_phong
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tao_ma_dat_phong();









CREATE SEQUENCE sequence_ma_hoa_don	
start with 1
increment by 1
minvalue 0
maxvalue 1000
cycle;

CREATE OR REPLACE FUNCTION public.tao_ma_hoa_don()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
			
			UPDATE hoa_don SET ma_hoa_don = ma_hoa_don ||to_char(current_date, 'DDMMYYYY')  ||LPAD( CAST(nextval('sequence_ma_hoa_don') AS varchar(8)) ,6, '0' ) where ma_hoa_don = 'HD' ;
		--	end if;
			RETURN NEW;
	END;
$BODY$;



CREATE TRIGGER trigg_tao_ma_hoa_don
    AFTER INSERT on hoa_don
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tao_ma_hoa_don();




CREATE OR REPLACE FUNCTION public.dien_ngay_su_dung()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	 
	BEGIN
			
			UPDATE hoa_don_goi_dich_vu h  SET ngay_con_lai  = so_ngay from goi_dich_vu g  where h.ten_goi = g.ten_goi  ;
		--	end if;
			RETURN NEW;
	END;
$BODY$;

ALTER FUNCTION public.dien_ngay_su_dung()
    OWNER TO postgres;


CREATE TRIGGER trigg_dien_ngay_su_dung
    AFTER INSERT on hoa_don_goi_dich_vu 
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.dien_ngay_su_dung();






CREATE SEQUENCE sequence_ma_doanh_nghiep	
start with 1
increment by 1
minvalue 0
maxvalue 1000
cycle;

-- FUNCTION: public.tao_ma_dat_phong()

-- DROP FUNCTION IF EXISTS public.tao_ma_dat_phong();

CREATE OR REPLACE FUNCTION public.tao_ma_doanh_nghiep()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
			
			UPDATE doanh_nghiep SET ma_doanh_nghiep = ma_doanh_nghiep  ||LPAD( CAST(nextval('sequence_ma_doanh_nghiep') AS varchar(4)) ,4, '0' ) where ma_doanh_nghiep = 'DN' ;
		--	end if;
			RETURN NEW;
	END;
$BODY$;






CREATE TRIGGER trigg_tao_ma_doanh_nghiep
    AFTER INSERT on doanh_nghiep
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tao_ma_doanh_nghiep();











CREATE SEQUENCE sequence_ma_dich_vu	
start with 1
increment by 1
minvalue 0
maxvalue 1000
cycle;

-- FUNCTION: public.tao_ma_dat_phong()

-- DROP FUNCTION IF EXISTS public.tao_ma_dat_phong();

CREATE OR REPLACE FUNCTION public.tao_ma_dich_vu()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
			
			UPDATE dich_vu SET ma_dich_vu = ma_dich_vu  ||LPAD( CAST(nextval('sequence_ma_dich_vu') AS varchar(3)) ,3, '0' ) where ma_dich_vu = 'DVR' or
																																		ma_dich_vu = 'DVS' or
																																		ma_dich_vu = 'DVC' or
																																		ma_dich_vu = 'DVM' or
																																		ma_dich_vu = 'DVB' 
																																		;
		--	end if;
			RETURN NEW;
	END;
$BODY$;






CREATE TRIGGER trigg_tao_ma_dich_vu	
    AFTER INSERT on dich_vu
	FOR EACH ROW  
	
    EXECUTE FUNCTION public.tao_ma_dich_vu();






set datestyle to DMY;

INSERT INTO chi_nhanh
VALUES ('CN','Lam Dong','280 Hung Vuong, thanh pho Da Lat', '0912547874', 'dalat@gmail.com');
INSERT INTO chi_nhanh
VALUES	('CN','tp Ho Chi Minh','130 Ly Chinh Thang, quan 3', '0912547458', 'hcm_quan3@gmail.com');
INSERT INTO chi_nhanh
VALUES 	('CN','tp Ho Chi Minh','330 To Hien Thanh, quan 10', '0912541258', 'hcm_quan10@gmail.com');
INSERT INTO chi_nhanh
VALUES	('CN','tp Ho Chi Minh','689 Ha Ton Quyen, quan 5', '0912547458', 'hcm_quan5@gmail.com');
INSERT INTO chi_nhanh
VALUES	('CN','tp Ho Chi Minh','353 Binh Quoi, quan Binh Thanh', '0912547458', 'hcm_quanbt@gmail.com');
		


INSERT INTO ha_chi_nhanh
VALUES ('CN1','https://t-cf.bstatic.com/xdata/images/hotel/max1024x768/22931657.jpg?k=a915121c8908a2c158024b43e9abbdf5c5efb01cda36846d0f6eac28a8672878&o=&hp=1' ) ;
INSERT INTO ha_chi_nhanh
VALUES	 ('CN2','https://t-cf.bstatic.com/xdata/images/hotel/max1024x768/25111742.jpg?k=01238aca193d8a3647f91937380e6347028258cbc3c6fdbd616ed319de7fcd4b&o=&hp=1') ;
INSERT INTO ha_chi_nhanh
VALUES  ('CN3','https://t-cf.bstatic.com/xdata/images/hotel/max1024x768/247301698.jpg?k=aea33dff016e9517c2b30a14bf43e05317e88c18a96808d3d0559e24bc26f172&o=&hp=1')	;
INSERT INTO ha_chi_nhanh
VALUES	('CN4','https://t-cf.bstatic.com/xdata/images/hotel/max1024x768/226433013.jpg?k=12325ced07a983778ad96a3f4baa5464d7d329b1d283d93eed720d403ce73af0&o=&hp=1')  ;
INSERT INTO ha_chi_nhanh
VALUES	 ('CN5','https://t-cf.bstatic.com/xdata/images/hotel/max1024x768/226433029.jpg?k=491a5f417372a232947eb1c59301cd8e8c47e5f1a854cde1160adb87e9d415f1&o=&hp=1') ;


INSERT INTO khu
VALUES ('CN1', 'Khu 1') ;
INSERT INTO khu
VALUES ('CN2','Khu 1') ;
INSERT INTO khu
VALUES ('CN3','Khu 1') ;
INSERT INTO khu
VALUES ('CN4','Khu 1') ;
INSERT INTO khu
VALUES ('CN5','Khu 1') ;

INSERT INTO khu
VALUES ('CN1', 'Khu 2') ;
INSERT INTO khu
VALUES ('CN2','Khu 2') ;
INSERT INTO khu
VALUES ('CN3','Khu 2') ;
INSERT INTO khu
VALUES ('CN4','Khu 2') ;
INSERT INTO khu
VALUES ('CN5','Khu 2') ;

INSERT INTO khu
VALUES ('CN1', 'Khu 3') ;
INSERT INTO khu
VALUES ('CN2','Khu 3') ;
INSERT INTO khu
VALUES ('CN3','Khu 3') ;
INSERT INTO khu
VALUES ('CN4','Khu 3') ;
INSERT INTO khu
VALUES ('CN5','Khu 3') ;




INSERT INTO loai_phong 
VALUES (DEFAULT,'nho', 30, 2);
INSERT INTO loai_phong
VALUES (DEFAULT,'vua',50,2);
INSERT INTO loai_phong
VALUES (DEFAULT,'lon', 80, 4);
INSERT INTO loai_phong
VALUES (DEFAULT,'cuc lon', 120, 6);
INSERT INTO loai_phong
VALUES (DEFAULT,'tong thong', 200, 10);


INSERT INTO thong_tin_giuong 
VALUES (1, 1.8, 1);
INSERT INTO thong_tin_giuong
VALUES (2, 1.8, 2);
INSERT INTO thong_tin_giuong
VALUES (3, 1.8, 2);
INSERT INTO thong_tin_giuong
VALUES (4, 1.8, 2);
INSERT INTO thong_tin_giuong
VALUES (5, 3, 2);




INSERT INTO chi_nhanh_co_loai_phong 
VALUES (1, 'CN2', 1000);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (2, 'CN2', 2000);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (3, 'CN2', 3000);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (4, 'CN2', 4000);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (5, 'CN2', 9000);

INSERT INTO chi_nhanh_co_loai_phong 
VALUES (1, 'CN3', 1500);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (2, 'CN3', 2500);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (3, 'CN3', 3500);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (4, 'CN3', 4500);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (5, 'CN3', 9500);

INSERT INTO chi_nhanh_co_loai_phong 
VALUES (1, 'CN1', 500);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (2, 'CN1', 1500);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (3, 'CN1', 2500);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (4, 'CN1', 3500);
INSERT INTO chi_nhanh_co_loai_phong 
VALUES (5, 'CN1', 6500);







INSERT INTO phong
VALUES (2, 'CN2', 101, 'Khu 1');

INSERT INTO phong
VALUES (2, 'CN2', 102, 'Khu 1');

INSERT INTO phong
VALUES (2, 'CN2', 103, 'Khu 1');

INSERT INTO phong
VALUES (2, 'CN2', 104, 'Khu 1');

INSERT INTO phong
VALUES (2, 'CN2', 105, 'Khu 1');

INSERT INTO phong
VALUES (3, 'CN2', 201, 'Khu 1');

INSERT INTO phong
VALUES (3, 'CN2', 202, 'Khu 1');

INSERT INTO phong
VALUES (3, 'CN2', 203, 'Khu 1');

INSERT INTO phong
VALUES (3, 'CN2', 204, 'Khu 1');

INSERT INTO phong
VALUES (3, 'CN2', 205, 'Khu 1');



INSERT INTO phong
VALUES (1, 'CN1', 101, 'Khu 1');

INSERT INTO phong
VALUES (1, 'CN1', 102, 'Khu 1');

INSERT INTO phong
VALUES (1, 'CN1', 103, 'Khu 1');

INSERT INTO phong
VALUES (1, 'CN1', 104, 'Khu 1');

INSERT INTO phong
VALUES (1, 'CN1', 105, 'Khu 1');

INSERT INTO phong
VALUES (2, 'CN1', 201, 'Khu 1');

INSERT INTO phong
VALUES (2, 'CN1', 202, 'Khu 1');

INSERT INTO phong
VALUES (2, 'CN1', 203, 'Khu 1');

INSERT INTO phong
VALUES (2, 'CN1', 204, 'Khu 1');

INSERT INTO phong
VALUES (2, 'CN1', 205, 'Khu 1');




INSERT INTO loai_vat_tu
VALUES ('VT', 'ghe');

INSERT INTO loai_vat_tu
VALUES ('VT', 'ban');

INSERT INTO loai_vat_tu
VALUES ('VT', 'tu lanh');

INSERT INTO loai_vat_tu
VALUES ('VT', 'ti vi');

INSERT INTO loai_vat_tu
VALUES ('VT', 'dieu hoa');




INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0001', 1, 2);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0002', 1, 1);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0003', 1, 1);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0004', 1, 1);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0005', 1, 1);



INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0001', 2, 4);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0002', 2, 2);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0003', 2, 1);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0004', 2, 1);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0005', 2, 1);


INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0001', 3, 5);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0002', 3, 2);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0003', 3, 1);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0004', 3, 1);

INSERT INTO loai_vat_tu_trong_phong
VALUES ('VT0005', 3, 1);



INSERT INTO vat_tu
VALUES ('CN1', 'VT0001', 1, 'good', '101');

INSERT INTO vat_tu
VALUES ('CN1', 'VT0002', 2, 'good', '101');

INSERT INTO vat_tu
VALUES ('CN1', 'VT0003', 3, 'good', '101');

INSERT INTO vat_tu
VALUES ('CN1', 'VT0004', 4, 'good', '101');

INSERT INTO vat_tu
VALUES ('CN1', 'VT0005', 5, 'good', '101');



INSERT INTO vat_tu
VALUES ('CN1', 'VT0002', 7, 'good', '102');

INSERT INTO vat_tu
VALUES ('CN1', 'VT0003', 8, 'good', '102');

INSERT INTO vat_tu
VALUES ('CN1', 'VT0004', 9, 'good', '102');

INSERT INTO vat_tu
VALUES ('CN1', 'VT0005', 10, 'good', '102');




INSERT INTO nha_cung_cap
VALUES ('NCC','Bao Hung','baohung@gmail.com', 'Ho Chi Minh' );

INSERT INTO nha_cung_cap
VALUES ('NCC','Chau Hung','chauhung@gmail.com', 'Ho Chi Minh' );

INSERT INTO nha_cung_cap
VALUES ('NCC','Ikea','ikea@gmail.com', 'Ho Chi Minh' );

INSERT INTO nha_cung_cap
VALUES ('NCC','Channel','channel@gmail.com', 'Ho Chi Minh' );

INSERT INTO nha_cung_cap
VALUES ('NCC','Gutri','gutri@gmail.com', 'Ho Chi Minh' );




INSERT INTO cung_cap_vat_tu
VALUES ('NCC0001','VT0001','CN2' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0001','VT0002','CN2' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0001','VT0003','CN2' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0001','VT0004','CN2' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0001','VT0005','CN2' );


INSERT INTO cung_cap_vat_tu
VALUES ('NCC0002','VT0001','CN1' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0002','VT0002','CN1' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0002','VT0003','CN1' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0002','VT0004','CN1' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0002','VT0005','CN1' );




INSERT INTO cung_cap_vat_tu
VALUES ('NCC0003','VT0001','CN3' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0003','VT0002','CN3' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0003','VT0003','CN3' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0003','VT0004','CN3' );
INSERT INTO cung_cap_vat_tu
VALUES ('NCC0003','VT0005','CN3' );





INSERT INTO khach_hang
VALUES ('KH','251287478', 'Nguyen Van Linh' ,'0918874569', 'kh1@gmai.com', 'kh1_2022', '987654321' , default, default); 

INSERT INTO khach_hang
VALUES ('KH','251288478','Le Van Linh','0918874570', 'kh2@gmai.com', 'kh2_2022', '987654322' , default, default); 

INSERT INTO khach_hang
VALUES ('KH','251777478', 'Lam Thi Linh','0918874571', 'kh3@gmai.com', 'kh3_2022', '987654323' , default, default); 


INSERT INTO khach_hang
VALUES ('KH','259787478', 'Lam Van Doan','0918874572', 'kh4@gmai.com', 'kh4_2022', '987654324' , default, default); 



INSERT INTO khach_hang
VALUES ('KH','251212378', 'Lam Tu An','0918874573', 'kh5@gmai.com', 'kh5_2022', '987654325' , default, default); 



INSERT INTO khach_hang
VALUES ('KH','251789678','Lam Ho Xung','0918874574', 'kh6@gmai.com', 'kh6_2022', '987654326' , default, default); 


INSERT INTO khach_hang
VALUES ('KH','251214878','Nguyen Thi Linh','0918874575', 'kh7@gmai.com', 'kh7_2022', '987654327' , 15, default); 

INSERT INTO khach_hang
VALUES ('KH','251288479', 'Nguyen Thi Nhung','0918874576', 'kh8@gmai.com', 'kh8_2022', '987654328' , 20, default); 

INSERT INTO khach_hang
VALUES ('KH','251777498', 'Nguyen Thi Hong','0918874577', 'kh9@gmai.com', 'kh9_2022', '987654329' , 57, default); 


INSERT INTO khach_hang
VALUES ('KH','259787491','Nguyen An Dung','0918874578', 'kh10@gmai.com', 'kh10_2022', '987654330' , 89, default); 



INSERT INTO khach_hang
VALUES ('KH','251212392', 'Nguyen Gia Bao','0918874579', 'kh11@gmai.com', 'kh11_2022', '987654331' , 110, default); 



INSERT INTO khach_hang
VALUES ('KH','251789693', 'Nguyen Tien Truong','0918874580', 'kh12@gmai.com', 'kh12_2022', '987654332' , 160, default); 







INSERT INTO goi_dich_vu
VALUES (10,3,3000, 'Goi 1'); 

INSERT INTO goi_dich_vu
VALUES (15,3,4000, 'Goi 2'); 

INSERT INTO goi_dich_vu
VALUES (20,5,6000, 'Goi 3'); 

INSERT INTO goi_dich_vu
VALUES (30,5,7000, 'Goi 4'); 

INSERT INTO goi_dich_vu
VALUES (40,8,15000, 'Goi 5'); 

INSERT INTO goi_dich_vu
VALUES (50,10,20000, 'Goi 6'); 




INSERT INTO hoa_don_goi_dich_vu
VALUES ('KH000001','Goi 1','02-09-2022 15:04:05', '02-10-2022' ,0); 


INSERT INTO hoa_don_goi_dich_vu
VALUES ('KH000002','Goi 2','15-09-2022 08:12:19', '28-09-2022' ,0); 

INSERT INTO hoa_don_goi_dich_vu
VALUES ('KH000003','Goi 3','23-09-2022 04:55:34', '01-10-2022' ,0); 

INSERT INTO hoa_don_goi_dich_vu
VALUES ('KH000004','Goi 4','01-10-2022 20:41:07', '15-10-2022' ,0); 

INSERT INTO hoa_don_goi_dich_vu
VALUES ('KH000005','Goi 5','25-10-2022 17:02:47', '30-10-2022' ,0); 

INSERT INTO hoa_don_goi_dich_vu
VALUES ('KH000001','Goi 3','16-10-2022 18:02:45', '20-10-2022' ,0); 




INSERT INTO don_dat_phong
VALUES ('DP','15-09-2022 08:12:19', 3,'25-09-2022' ,'28-09-2022' ,0,0,'KH000001', 'Goi 1'); 

INSERT INTO don_dat_phong
VALUES ('DP','19-09-2022 10:12:19', 3,'24-09-2022' ,'28-09-2022' ,0,0,'KH000002', 'Goi 2'); 

INSERT INTO don_dat_phong
VALUES ('DP','15-08-2022 08:12:19', 10,'25-09-2022' ,'28-09-2022' ,1,0,'KH000003', 'Goi 3'); 

INSERT INTO don_dat_phong
VALUES ('DP','19-08-2022 10:12:19', 7,'24-09-2022' ,'28-09-2022' ,1,0,'KH000004', 'Goi 4'); 

INSERT INTO don_dat_phong
VALUES ('DP','15-07-2022 08:12:19', 5,'25-08-2022' ,'28-08-2022' ,1,0,'KH000005', 'Goi 5'); 

INSERT INTO don_dat_phong
VALUES ('DP','19-06-2022 10:12:19', 25,'24-07-2022' ,'28-07-2022' ,1,0,'KH000006', 'Goi 4'); 




INSERT INTO phong_thue
VALUES ('DP15092022000001', 'CN2', '101');
INSERT INTO phong_thue
VALUES ('DP19092022000002', 'CN2', '102');

INSERT INTO phong_thue
VALUES ('DP19092022000002', 'CN2', '201');

INSERT INTO phong_thue
VALUES ('DP15092022000001', 'CN2', '103');

INSERT INTO phong_thue
VALUES ('DP15092022000001', 'CN2', '104');

INSERT INTO phong_thue
VALUES ('DP15092022000001', 'CN2', '105');


INSERT INTO phong_thue
VALUES ('DP15082022000003', 'CN1', '201');

INSERT INTO phong_thue
VALUES ('DP15082022000003', 'CN1', '101');


INSERT INTO phong_thue
VALUES ('DP15082022000003', 'CN1', '102');

INSERT INTO phong_thue
VALUES ('DP19082022000004', 'CN2', '203');




INSERT INTO hoa_don
VALUES ('HD', '08:00', '13:00','DP19092022000002');


INSERT INTO hoa_don
VALUES ('HD', '19:00', '15:00','DP15082022000003');


INSERT INTO hoa_don
VALUES ('HD', '04:00', '12:00','DP19082022000004');


INSERT INTO hoa_don
VALUES ('HD', '05:00', '22:00','DP15072022000005');


INSERT INTO hoa_don
VALUES ('HD', '06:00', '18:00','DP19062022000006');






INSERT INTO doanh_nghiep
VALUES ('DN', 'VinAI');


INSERT INTO doanh_nghiep
VALUES ('DN', 'FPT');

INSERT INTO doanh_nghiep
VALUES ('DN', 'Trusting_social');

INSERT INTO doanh_nghiep
VALUES ('DN', 'KMC');

INSERT INTO doanh_nghiep
VALUES ('DN', 'Viettle');






INSERT INTO dich_vu
VALUES ('DVR', 'nha hang', 100 , 'chau a','DN0001' );



INSERT INTO dich_vu
VALUES ('DVS', 'spa', 20 , 'chau a','DN0002' );


INSERT INTO dich_vu
VALUES ('DVC', 'cua hang tien loi', 30 , 'chau a','DN0003' );


INSERT INTO dich_vu
VALUES ('DVM', 'do luu niem', 40 , 'chau a','DN0004' );


INSERT INTO dich_vu
VALUES ('DVB', 'bar', 300 , 'chau a','DN0005' );






INSERT INTO dich_vu_spa
VALUES ('DVS002', 'nan mun' );



INSERT INTO dich_vu_spa
VALUES ('DVS002', 'lan kim' );

INSERT INTO dich_vu_spa
VALUES ('DVS002', 'mat xa' );

INSERT INTO dich_vu_spa
VALUES ('DVS002', 'xong hoi' );


INSERT INTO dich_vu_spa
VALUES ('DVS002', 'ban laze' );







INSERT INTO loai_hang_do_luu_niem
VALUES ('DVM004', 'tuong' );

INSERT INTO loai_hang_do_luu_niem
VALUES ('DVM004', 'non la' );


INSERT INTO loai_hang_do_luu_niem
VALUES ('DVM004', 'khan ran' );


INSERT INTO loai_hang_do_luu_niem
VALUES ('DVM004', 'ao dai' );


INSERT INTO loai_hang_do_luu_niem
VALUES ('DVM004', 'mo hinh' );







INSERT INTO thuong_hieu_do_luu_niem
VALUES ('DVM004', 'Kinh Do' );

INSERT INTO thuong_hieu_do_luu_niem
VALUES ('DVM004', 'Ai Phuong' );


INSERT INTO thuong_hieu_do_luu_niem
VALUES ('DVM004', 'Mai Linh' );


INSERT INTO thuong_hieu_do_luu_niem
VALUES ('DVM004', 'Thanh Buoi' );

INSERT INTO thuong_hieu_do_luu_niem
VALUES ('DVM004', 'Song Xanh' );






INSERT INTO mat_bang (ma_chi_nhanh, stt_mat_bang, chieu_dai, chieu_rong, gia_thue, ma_dich_vu)
VALUES ('CN2', 1, 50, 30, 10000, 'DVM004' );


INSERT INTO mat_bang (ma_chi_nhanh, stt_mat_bang, chieu_dai, chieu_rong, gia_thue, ma_dich_vu)
VALUES ('CN2', 2, 450, 50, 40000, 'DVC003' );

INSERT INTO mat_bang (ma_chi_nhanh, stt_mat_bang, chieu_dai, chieu_rong, gia_thue, ma_dich_vu)
VALUES ('CN2', 3, 300, 150, 30000, 'DVB005' );


INSERT INTO mat_bang (ma_chi_nhanh, stt_mat_bang, chieu_dai, chieu_rong, gia_thue, ma_dich_vu)
VALUES ('CN2', 4, 600, 100, 70000, 'DVS002' );


INSERT INTO mat_bang (ma_chi_nhanh, stt_mat_bang, chieu_dai, chieu_rong, gia_thue, ma_dich_vu)
VALUES ('CN2', 5, 1000, 300, 100000, 'DVR001' );









INSERT INTO hinh_anh_cua_hang 
VALUES ('CN2', 1, 'https://imgur.com/gallery/SP6MWqB' );



INSERT INTO hinh_anh_cua_hang 
VALUES ('CN2', 2, 'https://imgur.com/gallery/SP6MWtB' );



INSERT INTO hinh_anh_cua_hang 
VALUES ('CN2', 3, 'https://imgur.com/gallery/SP6NWqB' );


INSERT INTO hinh_anh_cua_hang 
VALUES ('CN2', 4, 'https://imgur.com/gallery/SP7MWqB' );


INSERT INTO hinh_anh_cua_hang 
VALUES ('CN2', 5, 'https://imgur.com/gallery/SP6MWqA' );







INSERT INTO khung_gio_hoat_dong_cua_hang 
VALUES ('CN2', 1, '08:00', '12:00' );


INSERT INTO khung_gio_hoat_dong_cua_hang 
VALUES ('CN2', 1, '14:00', '18:00' );

INSERT INTO khung_gio_hoat_dong_cua_hang 
VALUES ('CN2', 2, '08:00', '11:00' );

INSERT INTO khung_gio_hoat_dong_cua_hang 
VALUES ('CN2', 2, '13:00', '17:00' );


INSERT INTO khung_gio_hoat_dong_cua_hang 
VALUES ('CN2', 3, '07:00', '12:00' );


INSERT INTO khung_gio_hoat_dong_cua_hang 
VALUES ('CN2', 4, '08:00', '12:00' );


INSERT INTO khung_gio_hoat_dong_cua_hang 
VALUES ('CN2', 4, '15:00', '20:00' );

INSERT INTO khung_gio_hoat_dong_cua_hang 
VALUES ('CN2', 5, '08:00', '17:00' );







