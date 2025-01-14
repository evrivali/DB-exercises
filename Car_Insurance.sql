PGDMP     1    ;                y           Car_Insurance    13.2    13.2 .    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    57721    Car_Insurance    DATABASE     s   CREATE DATABASE "Car_Insurance" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_United States.1252';
    DROP DATABASE "Car_Insurance";
                postgres    false            �           1247    57895    my_type    TYPE     �   CREATE TYPE public.my_type AS (
	contract_code character varying,
	driver character varying,
	client character varying,
	contract_start_date date
);
    DROP TYPE public.my_type;
       public          postgres    false            �            1255    82555 
   getquery()    FUNCTION     d  CREATE FUNCTION public.getquery() RETURNS SETOF public.my_type
    LANGUAGE plpgsql
    AS $$ --το αποτέλεσμα της συνάρτησης θα επιστραφει με βάση τον τύπο που έχω δημιουργήσει (βλ. σκρινσοτ)
DECLARE 
  my_cursor CURSOR FOR select insurance.contract_code,drivers.fullname as drivers_fullname,clients.fullname,contract_start_date from clients inner join insurance on clients.contract_code=insurance.contract_code inner join drivers on  clients.contract_code=drivers.contract_code WHERE contract_start_date >= date_trunc('month', current_date ) and contract_start_date < date_trunc('month', current_date + interval '1' month);
 --υλοποιώ το query μέσω του cursor που έχω δημιουργήσει
  rec my_type;--δηλώνω μεταβλητή του τύπου που έχω δημιουργήσει
BEGIN
  OPEN my_cursor;
  FETCH my_cursor INTO rec.contract_code, rec.driver,rec.client,rec.contract_start_date;    -- Διαβάζω πρώτη γραμμή απο τον cursor 
  WHILE FOUND LOOP
    RETURN NEXT rec;                                 -- Return the data to the caller
    FETCH my_cursor INTO rec.contract_code, rec.driver,rec.client,rec.contract_start_date;  -- Διαβάζω γραμμες μέσα στο loop
  END LOOP;
  CLOSE my_cursor;
  RETURN;
END;
$$;
 !   DROP FUNCTION public.getquery();
       public          postgres    false    655            �            1255    82552    update_contract()    FUNCTION     �  CREATE FUNCTION public.update_contract() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
update insurance set contract_end_date = contract_end_date + interval '1 year' where  contract_end_date =CURRENT_DATE and categoryid in (select categoryid from vehicle_category where vehicle_category.insurance_group='professional') ;-- αν η ημερομηνία κάποια εγγραφής είναι ίση με την τρέχουσα ημερομηνία και αν η ασφαλιστική κατηργορία είναι επαγγελματική τότε κάνω update τον ζητούμενο πίνακα και αλλάζω την ημερομηνία λήξης του συμβολαίου
return new;
end;
$$;
 (   DROP FUNCTION public.update_contract();
       public          postgres    false            �            1259    57732    address    TABLE       CREATE TABLE public.address (
    street character varying(20) NOT NULL,
    street_number integer NOT NULL,
    postal_code integer NOT NULL,
    city character varying(20) NOT NULL,
    address_id character varying(5) NOT NULL,
    country character varying(30) NOT NULL
);
    DROP TABLE public.address;
       public         heap    postgres    false            �            1259    82526 	   caused_by    TABLE     �   CREATE TABLE public.caused_by (
    caused_by_id character varying NOT NULL,
    registration_number character varying,
    violation_id character varying,
    driver character varying
);
    DROP TABLE public.caused_by;
       public         heap    postgres    false            �            1259    57737    clients    TABLE       CREATE TABLE public.clients (
    fullname character varying(30) NOT NULL,
    contract_code character varying(20) NOT NULL,
    email character varying(30) NOT NULL,
    phonenumber1 character varying(20) NOT NULL,
    phonenumber2 character varying(20),
    driver boolean NOT NULL
);
    DROP TABLE public.clients;
       public         heap    postgres    false            �            1259    57757    drivers    TABLE     2  CREATE TABLE public.drivers (
    fullname character varying(30) NOT NULL,
    gender_id character varying(5) NOT NULL,
    birthdate date NOT NULL,
    address_id character varying(5) NOT NULL,
    drivers_license_number character varying(20) NOT NULL,
    contract_code character varying(20) NOT NULL
);
    DROP TABLE public.drivers;
       public         heap    postgres    false            �            1259    57727    gender    TABLE     �   CREATE TABLE public.gender (
    gender_id character varying(5) NOT NULL,
    gender character varying(15) NOT NULL,
    pronnouns character varying(10) NOT NULL
);
    DROP TABLE public.gender;
       public         heap    postgres    false            �            1259    57797 	   insurance    TABLE     q  CREATE TABLE public.insurance (
    insuranceid character varying(5) NOT NULL,
    contract_code character varying(20) NOT NULL,
    car character varying(7) NOT NULL,
    contract_start_date date NOT NULL,
    contract_end_date date NOT NULL,
    valid_con boolean NOT NULL,
    con_cost character varying(10) NOT NULL,
    categoryid character varying(5) NOT NULL
);
    DROP TABLE public.insurance;
       public         heap    postgres    false            �            1259    57722    vehicle_category    TABLE     �   CREATE TABLE public.vehicle_category (
    categoryid character varying(5) NOT NULL,
    vehicle_type character varying(15) NOT NULL,
    insurance_group character varying(15) NOT NULL
);
 $   DROP TABLE public.vehicle_category;
       public         heap    postgres    false            �            1259    57777    vehicles    TABLE     �  CREATE TABLE public.vehicles (
    car_vin character varying(20) NOT NULL,
    registration_number character varying(7) NOT NULL,
    manufacturer character varying(15) NOT NULL,
    model character varying(20) NOT NULL,
    color character varying(10) NOT NULL,
    release_year integer NOT NULL,
    cur_value character varying(10) NOT NULL,
    contract_code character varying(20) NOT NULL,
    categoryid character varying(5) NOT NULL
);
    DROP TABLE public.vehicles;
       public         heap    postgres    false            �            1259    82518 
   violations    TABLE     �   CREATE TABLE public.violations (
    violation_id character varying NOT NULL,
    violation_date date,
    violation_time time without time zone,
    short_descreption character varying
);
    DROP TABLE public.violations;
       public         heap    postgres    false            �          0    57732    address 
   TABLE DATA           `   COPY public.address (street, street_number, postal_code, city, address_id, country) FROM stdin;
    public          postgres    false    202   E       �          0    82526 	   caused_by 
   TABLE DATA           \   COPY public.caused_by (caused_by_id, registration_number, violation_id, driver) FROM stdin;
    public          postgres    false    209   /O       �          0    57737    clients 
   TABLE DATA           e   COPY public.clients (fullname, contract_code, email, phonenumber1, phonenumber2, driver) FROM stdin;
    public          postgres    false    203   kU       �          0    57757    drivers 
   TABLE DATA           t   COPY public.drivers (fullname, gender_id, birthdate, address_id, drivers_license_number, contract_code) FROM stdin;
    public          postgres    false    204   �h       �          0    57727    gender 
   TABLE DATA           >   COPY public.gender (gender_id, gender, pronnouns) FROM stdin;
    public          postgres    false    201   6{       �          0    57797 	   insurance 
   TABLE DATA           �   COPY public.insurance (insuranceid, contract_code, car, contract_start_date, contract_end_date, valid_con, con_cost, categoryid) FROM stdin;
    public          postgres    false    206   �}       �          0    57722    vehicle_category 
   TABLE DATA           U   COPY public.vehicle_category (categoryid, vehicle_type, insurance_group) FROM stdin;
    public          postgres    false    200   ��       �          0    57777    vehicles 
   TABLE DATA           �   COPY public.vehicles (car_vin, registration_number, manufacturer, model, color, release_year, cur_value, contract_code, categoryid) FROM stdin;
    public          postgres    false    205   ��       �          0    82518 
   violations 
   TABLE DATA           e   COPY public.violations (violation_id, violation_date, violation_time, short_descreption) FROM stdin;
    public          postgres    false    208   ��       M           2606    57736    address address_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);
 >   ALTER TABLE ONLY public.address DROP CONSTRAINT address_pkey;
       public            postgres    false    202            Y           2606    82533    caused_by caused_by_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.caused_by
    ADD CONSTRAINT caused_by_pkey PRIMARY KEY (caused_by_id);
 B   ALTER TABLE ONLY public.caused_by DROP CONSTRAINT caused_by_pkey;
       public            postgres    false    209            O           2606    57741    clients clients_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (contract_code);
 >   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
       public            postgres    false    203            Q           2606    57761    drivers drivers_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_pkey PRIMARY KEY (drivers_license_number);
 >   ALTER TABLE ONLY public.drivers DROP CONSTRAINT drivers_pkey;
       public            postgres    false    204            K           2606    57731    gender gender_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.gender
    ADD CONSTRAINT gender_pkey PRIMARY KEY (gender_id);
 <   ALTER TABLE ONLY public.gender DROP CONSTRAINT gender_pkey;
       public            postgres    false    201            U           2606    57801    insurance insurance_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.insurance
    ADD CONSTRAINT insurance_pkey PRIMARY KEY (insuranceid);
 B   ALTER TABLE ONLY public.insurance DROP CONSTRAINT insurance_pkey;
       public            postgres    false    206            I           2606    57726 &   vehicle_category vehicle_category_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.vehicle_category
    ADD CONSTRAINT vehicle_category_pkey PRIMARY KEY (categoryid);
 P   ALTER TABLE ONLY public.vehicle_category DROP CONSTRAINT vehicle_category_pkey;
       public            postgres    false    200            S           2606    57781    vehicles vehicles_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (registration_number);
 @   ALTER TABLE ONLY public.vehicles DROP CONSTRAINT vehicles_pkey;
       public            postgres    false    205            W           2606    82525    violations violations_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.violations
    ADD CONSTRAINT violations_pkey PRIMARY KEY (violation_id);
 D   ALTER TABLE ONLY public.violations DROP CONSTRAINT violations_pkey;
       public            postgres    false    208            e           2620    82553    insurance update_contract    TRIGGER     x   CREATE TRIGGER update_contract AFTER UPDATE ON public.insurance FOR EACH ROW EXECUTE FUNCTION public.update_contract();
 2   DROP TRIGGER update_contract ON public.insurance;
       public          postgres    false    206    210            d           2606    82544    caused_by caused_by_driver_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.caused_by
    ADD CONSTRAINT caused_by_driver_fkey FOREIGN KEY (driver) REFERENCES public.drivers(drivers_license_number) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.caused_by DROP CONSTRAINT caused_by_driver_fkey;
       public          postgres    false    204    209    2897            c           2606    82539 ,   caused_by caused_by_registration_number_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.caused_by
    ADD CONSTRAINT caused_by_registration_number_fkey FOREIGN KEY (registration_number) REFERENCES public.vehicles(registration_number) ON DELETE SET NULL;
 V   ALTER TABLE ONLY public.caused_by DROP CONSTRAINT caused_by_registration_number_fkey;
       public          postgres    false    205    2899    209            b           2606    82534 %   caused_by caused_by_violation_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.caused_by
    ADD CONSTRAINT caused_by_violation_id_fkey FOREIGN KEY (violation_id) REFERENCES public.violations(violation_id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public.caused_by DROP CONSTRAINT caused_by_violation_id_fkey;
       public          postgres    false    208    2903    209            [           2606    57767    drivers drivers_address_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address(address_id) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.drivers DROP CONSTRAINT drivers_address_id_fkey;
       public          postgres    false    2893    204    202            \           2606    57772 "   drivers drivers_contract_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_contract_code_fkey FOREIGN KEY (contract_code) REFERENCES public.clients(contract_code) ON DELETE SET NULL;
 L   ALTER TABLE ONLY public.drivers DROP CONSTRAINT drivers_contract_code_fkey;
       public          postgres    false    2895    203    204            Z           2606    57762    drivers drivers_gender_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_gender_id_fkey FOREIGN KEY (gender_id) REFERENCES public.gender(gender_id) ON DELETE SET NULL;
 H   ALTER TABLE ONLY public.drivers DROP CONSTRAINT drivers_gender_id_fkey;
       public          postgres    false    204    201    2891            `           2606    57807    insurance insurance_car_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.insurance
    ADD CONSTRAINT insurance_car_fkey FOREIGN KEY (car) REFERENCES public.vehicles(registration_number) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.insurance DROP CONSTRAINT insurance_car_fkey;
       public          postgres    false    206    2899    205            a           2606    57812 #   insurance insurance_categoryid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.insurance
    ADD CONSTRAINT insurance_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.vehicle_category(categoryid) ON DELETE SET NULL;
 M   ALTER TABLE ONLY public.insurance DROP CONSTRAINT insurance_categoryid_fkey;
       public          postgres    false    2889    200    206            _           2606    57802 &   insurance insurance_contract_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.insurance
    ADD CONSTRAINT insurance_contract_code_fkey FOREIGN KEY (contract_code) REFERENCES public.clients(contract_code) ON DELETE SET NULL;
 P   ALTER TABLE ONLY public.insurance DROP CONSTRAINT insurance_contract_code_fkey;
       public          postgres    false    206    2895    203            ]           2606    57782 !   vehicles vehicles_categoryid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_categoryid_fkey FOREIGN KEY (categoryid) REFERENCES public.vehicle_category(categoryid) ON DELETE SET NULL;
 K   ALTER TABLE ONLY public.vehicles DROP CONSTRAINT vehicles_categoryid_fkey;
       public          postgres    false    200    205    2889            ^           2606    57787 $   vehicles vehicles_contract_code_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_contract_code_fkey FOREIGN KEY (contract_code) REFERENCES public.clients(contract_code) ON DELETE SET NULL;
 N   ALTER TABLE ONLY public.vehicles DROP CONSTRAINT vehicles_contract_code_fkey;
       public          postgres    false    2895    205    203            �   
  x�eWˎ�]_}�~ �"��"�R?�OM��=ndCI���RQ�G�ݫ�2�lY&@0�Y�.Ȯ'?�/ɹe�-O`6l6�>΋G�mc��qAVZC��V�C(�p��.�p�C�h�2qK�X��ҕ��X�qKZ22���\�lp�Z�@�E�|�`ڭ׾ޅ���vC&U���rW�Ȥ�����+J_�ʍ �&Bб{���n������,�7���7���y���tN����U?T�:}AGE����U�G7o�?A"�&�q��tVv��
�4ʌ�����*�\�UyNi������Ë���"���������P�������NmF���U���z�ʵ�h����J�e��Y�%���3ݺ�İS��Q�Ғ�.���b��m�VBY�f������n�_OU�����q�
�r��$�$�,4��j�`b������GuD1��T�6)UF�[��i�P�H��wU�+����r�� 1����˸(ג�`S�д���Q�ΰH!S�qէP-.��ٕ�/�� 供w���F�����+���݅�a$ɠ���\]�e������9��q�Z��������%��J�o\�����}��\�E�=Y4���@�뿟�I�L��Ν����!x,+3�P;�\���a[�Q��VW�z$lB��Ut�[��/��^,���;�̐���$.~�۬v W
	���y1��nV����9V��!!,�y�	|~��,��B�Y�����
�22����-]�&l��oZܞ��i����&���C2�8��["�^��n��W��o[_�BaR�.T��^��_UC��G:+P�gH	�[��m�/������~KW�mK?<-}WS*V <�C$�g�z�u����-EY����ZWc�I�}�w?.;���$(��h�eM�z����7+@I���Y��?�geb���EW�@�IǠ��!+����-P	�W�)�N�_��fB?�|�5��ˢ%&�ɓ����*� 7��3_�H�(������O�y����� p5�� �UT�W�y�1�rk�{���3F�����)����ݛ��V��c�$��2�C�9i�K��������F(�e.@z� x#:5�����-�N
�)d8ϴ�¢�ڌ��u��[L�I&iB���s�+����`��+֚��E�@<w����b�L	�v���{ݳ�g)&8�]W�I�>�x�Co�zQx����,x�͎����U�`;٣��C�\�eX�UY���M6��ku�+t\��
�'�^���T	(}�U�e?&���A�Wnx!e�(����܅��7��t�̉�l`����і�i���
8��-�Z����w��},\/�[\jL>����kV-��ё��ζ{�'��37���������1�=%�[A�'� �����tSCn�v򈩂R	��˶�H%N�_�.ǕǝZAiRc���؀�(3�0��ޯ���I�<�v�+��7IOi���&�(vp���9�]C�׮F���ܦ����-��҉x���c���E�48x�ܭ�����X��޿O .ʔJ"��e�c�2��0+���8l%�3�q�,�IŦ)�論G��H��V2K�/Ì���C����Q5 Ǩ���J��+��ꪅg��k�Ե]����+�� E�*#!Fd
/�k��V���0u�O<Ҩ����ǆyi���˓�yb�ps��d�j(��� 5���^� I>��۴!���Q�{��K��5� ���̄�!������k&�ׇ}���k�p��1�Rt^v�O�������3<��4Mg�N�ރ
\����У���zV���$rDJ�9N.".O�~�q�->��L�BSE�ү0�E�ܜ��!E�3��[���د3�2��-tYé��vU=��K�nU�<ր j���$:p�^|/}�;�:�?~�EX��R	:i�.A��)K�����߼�$�-0Y#�[�A%Ȕt�Q����}glZ#�»2Bn����U����K:�m��{��g�S�X�(�Z��������Q
�?��ShY�2k�hܕK�
x�Kv��|/�����^��O�H�΋�o	�b��0��z{����n��a�YjQ� lÜӎ�G� ��1ϑT�D��[�}�"�9~��φe����:�l�Rp05��M臗YDg< ��xI����3�@K�n�Ȅ'�s隢�N�:���(co���je~��K8��&n0	�-0�*z�ˮ�h�	h�"~��)�W��h�W�/��WKCS�3���
V�E�<9�$Z��^?F�2�TsؠU`5�ka�����w��a+	��+�(�5@���-_�_��\���nx�o�@����d��p��3�`��ڪuC�$n_c?��<�z�̑�=N��2���W��7q}����t �i��>�~`�"&n[��K��U#C�b��$�0_�C"��'��"6n''���S��P"���/c[ƧUo<��//�ځH��H�&���6E�b��S����%�A"�r��k�%��ѿG�����`0�4�ԗ      �   ,  x�UVɲ�8<�}̔$@���ݎ��������U�P�4M+Y�"N&� �&��Ål�E3�C��qOy���%Bb�{MN��ڂ7�q6��g�lo��ǐ�e,�xkbɅ�%ne�Fl�����|�A��`�Ѹ�v�AAA IKL�`XL���3�A�Fc�p���lӤ��]�qb�=�*���_�먍s������ZE�ާ&�O�B�_�`�ɱ��K�i�.-�s.�)�V����}�t�H=�A�)���1�5F���w��`��*z�$0�����6��#!���L��b�r?�r�&�/���]n�u�T��sF���Fv���zO��BfS�� 0���9Ov�y�5xK�NH�R譛L}��y?�Y�k�g�)�����?Z�ZC�+G���R��n�Jgg6n����Wn���X�3�7�ޖf����\Œ��ҝrؚ��R���L_�=Qav`lI�+c��U���N�
����j�rדJ��I��:��V�����o-�ʿd������P�,rMԊ����*>�
8�.d��� �κ�{�Q�4Sy"�2��%t�F*�m�+@�r~�9�4�7�{�w���O7�{e�.��w������L6�r�F��V;��%��n�89M_��'cx����6iq����2���K�I��tGr�S���^�+N �9�{��a�e謁+�8*�!��KlB�����f>G�Ҽl�$c�&x�D��t	.Z?���w�Z*���!��T�IX]��ʹy=SE^u��5X�wL��K��j�s�φE5�oo�y�ԏ^=��#m�v�]��r�����y)Z�H�g�1h0�Dgd��X�Wu���
��q	�1���.�i�,�|*��%�ۼ�I�c�Oq��2�я�xW��s�1f&�
�mR@��)�.�E����g}e������5����Ż/�R2��Wgk�՝u���t����ME669M��&3�D��Om�E��[���7��H�Qdq5M���@j;n�'\�Z���d��"7�^�`�����F���t�bQ��l���O��� ��6�e3����^88�0�����H�E;�����@��C{X�c��������y4��n�w7;6v�����ƶ����Fn�pBt^�S��:�N�[B�& �a���Ǐ)�Q�N&Yi��s���*=8X����}�G��Z�u�T�zP�ߕ͌0-�}/�Ws�o�z����ک�A�R�Iu��eQ~ߎQ������p�O�J���|�%�\W���=�f��	�|RK�PUr�N�ܢ����}ڠ�O�S�رw��U>��Y�@�q��W�Q_�!#
*�S]�RgP��|�9Z�E���uZ�Ϳ����%Y���b�~cU���_��7� �|��o\Z������Ļ��~J��7n�=�gp�OnxĞ���׏��?�-�{?������P�|xw�Ɲp��>��7��<����~��!�|:x��$>�}#^�q�1�����J�a~�%6�c�1�����C+���o��K�Z������s��oI��w���/>��a|�K�~���?���k      �      x�eY�r�8�]��B���� �Q�d͓��$���")+��JY��:����	_�{��������Sl�Bw|=n�}c�$6Ir7y�E�f��k�뾯a��ګs_(��W��&֦��I�g�׫@u?��h3d$;���AC�qH�S��'�~�R��|�My=��{���Ĥ���Fq�u6�U+N�m��皜N67�����r;�o��B�G��u�4��5MLY>jMs;�MJ�^Oy��X�[�$��'qz�a��ȳ�Wu���dA]q�����n��??M����֢g��|�����fEIR�����OYvJ�-S�N}U��V�/�A�r�M�۲6�6�9�&�|F���;� �c�]lY���eڢ*��<���P�(?�Kx>G����ˬ��m������R�o��\���Q��1F^0W!CQT�ôO��\��<�b[�ߊ}*H��h�P�ǻ ��4�kr�m��|U���+�յ�-�!��6���ֆ�ܐ�lHo;���q�#����B������ �u]K�_�������픘��:�M��}cl��9��|��H���9��Y���<f���yu�/�Cj�+_>��G����5���ǧsI�ق���/��	#��$_IV�&���x�yKmI�����yP/�cSZ���l���^�V�'����h�!����QSl�������A7�R4����x<U�~chǯc��{�$T�Q�G�$g�P&�T�����42�]Vğ�m+��ՠ�Ʈ�I�_���;��Pz#�"z�{ֲ̮g��4yqy��C/�y�՝�fy��!j(l��E�4`�@�3\N�=ɽ��c�<j ���i[��P����$Idң}|��b~�'����3@�+Y�X��mkc[���7
D�ݟ6&-�D�2��q��ípk�q�� ��J
-u�SN�U��<.M��ݱ���;��6�����N�8=����b���3��*���I��7�cn>K�	�J�Wtژ�r�n���y���_LjN��I�L���8`�iTkg��Ԛ��rx�]�r0c�e�r����M�b�HYHQ(N�@�@a_�s���4Iv�k��!�������
8�O��dү�įJ��G�y])��tݱ<W�a�,u|�¾�^6r��f!V��J��b@�6O��FQ\>w. @)��J�f��a�n��%���Z^{�Zib�[�^���1��h]�ኩ���K|1�F�����d'W,hϼ�v�ȯ�qL���,C��#�����I\9X@.���bs�Z�Ils�s�M�t�܏9�η��7Na~���_Gr�Ԋ��,��֖%X� ���6}����&��E�^�Ԕ���JGAwA +��L��c����L�^�o��Gc��'�\l ���az.�n_���P�P�K�v��¶B��<��־���������I�<�����"J��%�5XWJ  -��S��&�m�E���Ӓ������ր��h.Y�ʊ03_$Fy>�}���'%wn�z$@z��J���'��]�,��m��l�=~���~%��sqO�ԖзRZ'l+�l'ǃQO���&���[R���Y��UT����j���#���K��>����v�Xsr�`�$���g�'��+�AK����
�Oq�p\/y@^�=B93���f��f�J�'����]��4�����<`�98A8���q����{����.�zC1��$�
b����bS�����?���5f�k�5�vme�1y2k�W����x�AX�D���㫉��"{Q�3�!H���C3j��y#��t�\�aW���G���ڟ�2���}�|	� ���8�ú83��9!=:br>��,wR���&?e`�����%��v��RB�sG��|�q���f7���h*��ި�Ht}DG\�RXɳ;��`R!���y@;�rA�7[ԚY�C�RK���כ����M��!�A�.��0���ۡ��2��{s�j��AP���N��,�H�t2���T���&��A����Ⱥ�k�Cg��3�ɉ��)�;df���bӒ��g�_N�����X�X��J��88D[8[�T]�2p���)鲞���z;܎%�>&&>Y*«ͮ�.��+���|���	�(���,=U�L�r�e'���sN����v����
�����ԝ�QB;_�����{1|8Y� >�ΰ��Wq���p��M�U̱#��#4q�H�&e�d���.,� S>bj�����P��9���
X��W'�υ��p+��~�fR�k�'-�����k�fs�\ �8����	a����{�Cb�|?vi���d�Oh0���t�H�!.�Ԅ���!��
 � �T ���`�1KϱF�Z&g%*hmTS���o�;]N~�2rz)���5x�|�5��3?�Q�d�5޾ц?�ܝi��О���9Թ�H'��(F٥	(lmw˿p�5������b2@6I�t��(<Ā&���͓�%��9���j�|���y3�b���i%�J-d�0���
Ad�Ǭ�l�c�&a|Țﹿm�]s� W�X4�~�m���z��$�p����4ùA`�=<Qb�/h��1t�#04Q��6��^Gs}2W�_�61;�	.Y8�5>����w���F�Z�� .'���Aψ���y&Mbk(��uMs�r8%��ڱ����n~졭�.P؜�a�����ͳ�nې�1?F$�@ZH����4���=>����f�r/[��: _�s������k�QD���r�A5{��%~'GP%8�	ؠ%��Q? ��đ-��_#��ր��Ac��/p����}KkȜn�j}��b��	<l�M��ߕ������NJ�r<��L18�\T�x=ڰIg�W�r�+���\z��"�	�c �<�%����0��SkB���9���ni9�no0vr8Xǌ��{ �UB���A(X�w�n�;�8�v���%��d�{�x_��=(
��:�B���Y�6��<�F�O%�%��g@�����pudF��o��t3;�q��`
za���)l��\���PٵI|���.�����j���}r?�֖�����&*�b�����+f���?H�?�ꃹ��v˝w��Ӎ�t&�5(p�Lhb*�?�h�3�(����Յ�o��]��m��?p��ۏi�[6s�ܙE���i3��*�>��!�A瑤�g����l�0���K��U�$�Ϗ8�i��L�b�_	�V�}���9�'+�s ��t���C��\��{^�@o��%Y��������CZ	����~��`X2L�&����������<����r�H�A�$����
�*G�˯��4Z�B�1յ�(����Uo���4q� H���(u�}�O�	61�<���@�hb2ғ@��t����! XÌ��CkQt�z&r%!5k-_��i~Z0��-� '��V��JM��#��jJ��?q��� �OE��UTm���Ҵ9V�F������"���p{��Q.�`{_k������"p� �G^)i/7�a)��]�7�5^lr1�{�d���Ȉq���`4���W���ڻ�u���D�^���<�S�$�������I|��ۋ8@F���\(ǹ:x�D��!�����ݔLԒy��\>���K\�M�X����y$���zx.����!�9eG�P��������!���[M���l���/�H?�	�ޅ,gE�+s�< �����u7�3��=e�c{����;�|����1���B�$�tA=}8SC6r��nLZ�6%��qS��?/d�y�	���e���Y�:r��C�񼏵�\67��c�ݎg&C����;^�r��y�?�
A'�lm9�Ny_��H�>�D�Ȟ��ۅs H�GG�.�H't`�������e�^��ず��9�� �*�0�����z����^��>\��w��
�|����-�/��|՝Kb��)c:����{��<�����l��Y���]>Z�	��4˙ s  	)��*�О��8����DVZ1h��Q�: �icJ{1ڍ��s���<
vϷ����{9}�+x!�D�@0b�4�P�=��=��ۺ�g��.c�_Ow�1|4����bS����s�$Uգ�{��/q^[Ɵ�-�^|�z��G��L�� ڹ��Yf�����]�W�Ǫ���f�QNm��݆��X�ɻ^�>&���؞�Wf�,J�����W�xG�+ӂ��zƍ�,�J���z=�s�����O@H� P�nVGe��= ��w
B$&��]Wԫ<`���PH^8�~���:so�[��Y�ք��_�˥z�@�W�E-������As�<�����������&� ���b��9����l=wE�a��PRI��73Q�=�?�c�,i˕��S�o�F>�:[�,���9+���/��B���x1�ժ��К�}9����p�_��N��E���9���x��3�L �t�[e�0���T�Rmo)��)[��Z�C4�+���I_5i+*܃ ��*�H��>��Xn(Ѐ>
2D�Tk��c�H�m���J[�d��X��7�A���<���1*�u-B y�M&z;��N���x̮�bߦ4/O��Y��o*�r�|w/��;B Ⱥ㾃���v7�R��[,���ur_�[\V�2�	�/��n�`,BC��m��8?��c<�y�Â ��P�S��%�.7��hq��b�!v�4��>鲩P����]��$r��"�$�fr�}�M���$sF�m�]{�{��k*�]��7F՗��	�����+�75�뫝�lʜ��8q��tϣ�G�K\:��֍m��ך�t���a|~��� ��aӟX���_��o���      �      x�EY�r�H�>���9i���}#v s�%��Ev@b{�O?Y�<���Le��-)�q�\�}x���|}�HH#�)y��W#�KR"9���2���wU�p��lr�P������|}=�cvB������1��'$���9U�9�*C��O�����������^����F㸅T��`�h�!�����3LV_zh�#�/�<��.��ۗ��}����E�Q�p�y!�H�"Z�
g�`86Mڋ�8Ҹ�D3y�k��}ߞ���6�P$5 ���'a�"xL�x��z(��q��<l����y]��}���y���H��\��tr��RS�FM�k��ЁU�$���:���{wY�?l&BH��lM^(�FM��8��4�qC� _�R҅n�vP֟��c��_�FS�A*Lo=�Fk��=9�AՒ+�:� �LL�ds:�]w^�o�u٧�uFѺ�*��{89!��A�Ō�ҫ!�L:5��<ƻ�|��ߗu�����z����7	���K!1��pK7U�����XZ�zl����e���#SF��Ҫ
� ��T�rdX�8O�k�,F��5�SНY~���ͷ7�!���&/ʂ-��U-f4��"̈�:b�O�Ꚉ��Gz�6/�\^a�<�(x�"x��C���%3������!�K����m��P���ľF��5ƾF��<R��g<�xp�}�p������׷�>��7�����&[�O�(OqM\@A��AK�
}�za�v���r�������P��-|�	����H��{z���X�
�oL��qb��/���������xl�@ډ�!����Z�BM7q��8S">��)<����b��ݯ��z�d�Tn��U}�
�Y�tG"Q��	ÊC-vL�Y�K�9�z���������� (HJ-B�gal	e`M��c�������W��ǎ�N9�-+�㮏��OT�#�Y��ϴ�L��Jv
���z�/�L*�@e;_��}�.�P]-da�����js@�S6@*ʃ�e	jH�e��I:���78��y��
���ۤ@"�����Os��9P/KJ�Ft]�f���
�4�^!�����m2'�G�Ս�X����Бyb��_{��u���{��X.�˧����g��'�sS�������(;��
�tT�~Y^� q��ϫ���X���'�� ���� �RE�� M���tI�N9��˺^��������n�W�ٖ��RbḄse��7�P�@�X���N�T�yٻ����H��d[Ql 8%zⳎ9�2�'�ɑ�C�g����]�x}��t��z���4���`k�` )�[��Rڣ��Q�q�|��� �z������ah��i��!�U�-�R�H$��"e"j3�I�BN&ɽ�������n����f�8�����Lr�"��ش�`�5�>����/�H=_7:\/��_�@e�8�91v����8`�tE�Nt�e�d��V��-�۲� z�l��6��b !��Ҽ�]�!����]sd�x^*!N3�>_�?`����`�E�\D�>�Ng������q�*�2�wx��ٵȄOx�z���e�m'�F#[R��.�Sir�4�
yB1		�RQ'Ucv���
���nv���v�l�͞�ċ/���9�Z���(G�:���0{@��������v���m�� �(�]�ZQ�Dw�a�k�Z�4i�xW�g@�j~=�k���'Y���G��'82�6�$E
���ʺ�m�t]��&����i�y�:%�:�U�@A��hʕ8��&Cb�̍�nX>�o����������F��Ҵ�����xV�/
U����܅�|�6ݷ����
,���f��(�a/b�D�J3�GxP�SE��;QQʝ?��������`���[.���5������QJ3N���E��]�\n (�r� ��	wj�2�5!}d�ix�&Oq�F�������]
b��П��շ̕[���6?��D�ߜ����m��د�ΝW�@�|^���r!f��V/�M�1e*�;o��A�5��ܰT ~�!H�m��~�c.��Ą��K�A@{5��ù9A����J�Q=�J�q*`�^p�WXJ����fm6�̷��j�Qt*�����<�?ao�j��VE��ۏǺZ��̜�_��8S@��7j`!�5x
T񂨲�MY;j\,�e��`B�I�02��/���0�܋b@�^�Z�=w� d����l���|�p�ۙ\ؠʊT�U�x�<��@��D4a�Q�'�y�����X�/7R���z�G#  �ZY�1�CxC��� �{ SS$ ������u?_~���[�1��$*�Ԕ�~J2 ���ܣE�Cu�e�w���O�e�aA�m%М�H�}Z*piؘ����)gtGb����]��Ujc��VI��&'p��1��p��4	k`�����j����F Jo�OE0X�|r �"?č&��e�����}�;7`�z,1��O�h���D��G�O$�L ri%Dc�=Mf���@.�u����uy��[y�����:����Z5R�Is�@<��Hy;I��[��Vr��V{@S���f�,�X
�K=熁�P
h�h���b�;�o������̖D@9<�"}�w-����"�T�!.��j�K���L'0#��������6rDm~q#|+��4J�2�	gĸQ�=Xi�ˬ�E0� ��ꯠ��.`�����7l$6����{A~�He�5� ���P{���RFI�n�1��p�_��9߯�Z@4+�l���ה�d$.�U�����b�� y�ί��� ��ǧտ�n\�)���8����A��`~3��W$���t��������-0Ά��7
?�9bЊ+a�NZ1�H���X�'���ĭ�`�X7�7��6��X#;��p͔�`�㢂�L�פ	�5��m�����=�Ɠ-2��@�.2���A�T�Lv�qE�N9qC+d@X��e�u�ۅ��Q������ �uA�FI4�4G���8���+_X�a����zغ��z�?u�2Q�wė)�Du��*t�9��Q�īe%�c�Ǻ����B��N���R��7��i`]94�A���
�ѨA�>����ӣ 2@a��gc}|��25�p8"-�@WG�k��E��ռ����s`��u�7�,?Q�]  ��L�Į��뛙Bi�%��4�]q�Lr���|b���o�����R�㩈ta������= �ʴӥ5l��y~*��������j�K�*Mfb-v�L��!n�+��,�|�/V҃��D��=
{�|���Ġ&*���M�Cʏ���W�	�yX��u� Eo�( ��<�X�' ����� �N�N#Zc��VA��t�����mKC�迯b�D4�$�F���>�B��l��{�z�b�H\��[�< �,m�F�КK����1
��ԙ?`G� J+�`���Z$7f��x��JW&����O��}EC�²����r��|��-��v�cx��k����NX�s�9�O���\�Z��*��[�zq�<�ޮ�Q=|_-�'�j�o�C{���N��)0>�ۺ=م�� Ƿٞ��6k����-���^�R|R:��RV��N��w��H翗�y;$\e��Km\ Ӄs_�Z`��5P���D��� �z����ק�.�Ow���Y-��I
UV����{�7GUwa-a�A7�����~X��;����y޵0����ѵ�HJ�5Qt��\(?dY�$f?�o�>����^O���ҷ���ԁ.(L�痠�}�5"30��a� ��/`��՞
,����`���#���G�D
i�qXV�u�WL:����w�u~�|\�}{��|Y1Ϭ��ό������6������$Nܴ.�Ʊ0�`I�պ�^�����X9ì���>#G��G\�6����Ls{�2�x*̮���'����"�>���XO�њ� Sk2"]��x��m�.9ۓ�! .  Z�=�K>���P����z��]��ߔ�2mW2�q��W�G �"5.�#���z����|���������ng�<c��5=�w��������n�]5����u?.�`�]�{|��SY ��H��m7[p�ȗ6ai&���]7p��������?����|g`�0X56��("��eH�ˢ��!��߿^(����,�P{��/o�d� ���e�ս(�^�B�x>n�)]��Q������lf����x��'/�I=��q�j�@?ú| �L�3�#��T�ÎX��5Z�M������d(WyLtY-�8�:0��hdǰp�.���	��X��������66F,"'1��ۃA7� ���1��X�L��y�w���(��-z���x%��:��s��"Q�Pe�#=�i�w�����g�;�=za­���)кF�Uͤ#S�x�5UHK����q���/P��cb�D{�}�Q	�T�@}:��knʾ�i�����z�d@%��{[�Ҵ��/\�v������� �D)>���G������v��ڻ      �   A  x�mU�r�0<���� x���?T?b����N��3�3u������T"��0v��BK���ԧ��������ߗ�2�(��Ÿ��t��?/�`��������h��������|i����(�.�������>��FEyhc�w�j�/w��*"v���.�E�f�i��4�)C�S���]�i܂
�Zəw�~��7 D�� !��f��TdKU��J��.��
�n��\�8 toP-S)�`�un.8!�&z����H4�u�f]�C2rV�Lxy��cU��4��C��#o��~�D�M
X�{z9c�QM���Q���23���p#
@o%�=2���a��9�ٰ�=m�
�V%p���	���q�Th籒��x/I��d�(�@�_a�a�� �etd�G�P��Sk[���&���W�k����գ�$���L���t�g��m3Ȟi'o�s����Ü��e�6�n�����6p��Ѩ8>�`�t67KP���e[F����(g-<f�i������0k����`:-������3�rT�=�H����éӵ���q:�όS��m�ar~q����}� �`N�      �   �  x�UyI��0l�}��8-%���<+��'�'�y|*�ĠH��;����Lv%�Him�Cw�Vs2o�dVN��K�_�]hB������+ceĀ�T��Oe�H�n�ڏ��r���y���\�І�'C#-I�-�T��IfZ�r�ү!�c	�}�ܗ�>�D�����s���@Gb��ZF��mad�t�r~���.�!��0&u�7N����P1����]fc)��e�rN��p�;����4�����k��N>�W껳%O&MƳTֆ�P��O�C��ZYz�d�$�/��K�d��_I�zgZ���,tG��Nb����J[����iT�G��mII2��k�kB���fX�I4�u�Z�ws
R�*D=�qϰ9cYP)X�a|I\�+	�QM���S)C[����(�$�8鶏R�IS>��I��*�x ��I�m��O*���T2$'W��?7�����$L�H��H���
2�X��#�m�2mG��cSb|x�D*�"�POՂX��$����l��̒m�������ԆfߡG=�0����H֐E�T�����I�T[�&��M�_�S}wG�����ym�=+�?�e�yl`5�B=L�C�ke.7ĺ&-m�,���]Jk׊��O��/1��F��ݙ�&��$��ͦ���������uݑoa��������tkԺ�>�/M����ӉtD�@�ЃM"N�$R#'Q�S��T5�x�rI�258�!I �K����"$��k)dbUm���Z8���0	�����qw�[̩� O����u�ɦzζI.K�H�ϗUJ�X�*��=ؐ�i<����K���3��%Y�a�ol���!�Q�F+���ڊ�5�ȩ�?]��ԤikX���}ɑ?Cl����J��\r�Oؔ\� e�Y-n��6���{���7�Opِ�$T׻n��V�j�\R�Q꾴�O>�I8��%&1�$	ͱé͎x�dJV�<Ln���eX'a����'���5�d�X�2�P��{�� �C�O����ʩ��X�Km�|[�i%���_��!~W�wui���?R�VڅdtW|=�K7lq_���@���!�����)����z"ߥN�VMa�2~�_!�	��0�.�5�$���uG�8�P�h�eZ�A���8���x(,���[W6�s�MC3�-������%�7%�p�vGH�ظA�"���d9
�Z��0Yrָ���!9���a�;����0����.R�Պ%��w�L�ɘ}`�t��*n:Ah�l�Kr1Q�΋��sl���k�r�^X���ē "P)X���ѹ�gN�婢���৻'�Ayd0��P�u���*���MRhr�HsF��f�ߵ���EU��&;��n�)�6Q��ɤ�#_��C�z�&I�b�[��r�5�*���WdLs������s�^ݪ�	\5o�����|�����qw�7���c��fr��T�ya���{�����E�?��֟���N���F�Q�aN�Q�N�*m�Lo�g��l��HC��T���NҕL��i~��%e�
`" 6���Q�Q�D�-戍3֒^4�\���e��o%���8�?��C�0��H����@���ʉ�F �<�R=2��[G<��u�	6�72@�t?��cMʢA�2�A<�l��0}��J�p�*i3���q���pC�#H\-͏���P���c�������`ۊ^��c1��y�bB�/í��r��Yy��ˮ��4��}�����'?�(S�ԩ$��>�-�6�]�bY�����7�כ��$��ms��`�	+Y�%`Ou|&'#Y��	ѫ���#�,�P�t0�+2= \>��Z^�#.�Y%NN�&�5n�XP��Q�\qTZ�#'r����&�.I�u��;��~^��иݬƜIQF�$ეeI?�qY���c!o����� 5��$��M�AFX9̗J�sդ�[��>�C�x���:�9ʢJB�I�7ͫT�qSj�]3r/bk�0����qI��SIt!#۔I~N�!H^��ɟ�d�ɛD�#'a�#X4n�0rc��.;KC��T>0�a��=ld�L5�HkƊ�L6���y^T#�*�BӗA�Í?�ǬD��7:Fٙl��딶�d��2���5N�Cօ�[�Wl���jqc��m-����>ױA��������T�k�#5�Ԕ�i�����V��:��>I�/1���� gr��a�f��C:��C"���ߚP��%�"�p��fG��
ɯ�%��&E^����������~Dk��:b��TrTr��RIΤGU�����峯��,���S���>T�U>���Q~��$�W������D;����t��(?yp[t���!ɸ�����Ɋ�:
�t��<e�7�(��n(�3�]�ʐ���\�>A_���4��?�8�=v��v��g�fǅ{ɞ��:�
�@l��d��a�4|�W�JՋ�b�=
a�Q�<P,�П�b�u��{�P;�bYҚ!NR��o�BޚП���I-g� �$ ���A�a�l�N�&��
�u�.��Т����&��0b��	3㨳��9��7kXzN_�p&�ۡB�e�w�@R/�33�]���@��ϙ�ϋ���X��DԽ�(q���쉦����-��Wk�0��_�w�I��x_�5�&r';|4�7��]I�Zt8��}i�!|z���Ys�m�4ĭ�祻��02��Z��{�`fEx��я�K��U��(=V����T �}��>�ϸ�m 繘� M�J�j�9�d��?��_���y��J�u5�É�hfgs�V���_A�ݙ����O��>�I8�j�@���`"{R z�i�㒏��!{���gB^���P�baQ,Md�ԟ\4sU�&�:K��Јy 4�CMPL�4NX�&��G���l���<�8~����!��ݔ$�܋��@3��V]kRR�+zB�[5��G�r6BР����(ѐK`���$A*�7p���`����R�G:��I�[+���Σ�$[��3t�G����L��`&�Ŋ디zT�pu�)���c�/��%	ݱx����%�&��l��fK���Ŋ�+���=������?l�֒�{dX
bf����6�rK����>����t>������j&�P���J�H��ʰ0�����|�G���%爭���/P�h�o}����x��>5�WX��Y.5R:bS|"����J�l5�,gaTx_w����
y/b��F�ct:fŒ�?���e������C�b�~�N:��H�,N��],I�F>/}���7�IB�]W�+9d�?O*��s�9�J�ؼMy�Kć�Sz�^I@�g5¤�����m=P�!�3!�$L�I�eB����N�-[tĽ4{��2�����~r�+b�byZqԟ�'(��b_���䜋��K�jS�w�?��v�$�\�t��#{�*'��jm|���]-����`sw0?�d�mT�ri�{8�H'��P�%⊯eR;���p����ϣ#�?���u��ǟ?��wl      �   $  x�}U�nA}���T�_S�.%$�/�R	5)�U���Feg�����{z���s���:l>�W��{�m����X=u{���s��Z�~D����w�'�E	�CϿ� ����ۯ�>m:��?����
N)�5�S���{<A�w��R�<�F�^���<�/tņ��̄rݚYX�.�UIw^g�xߎFr[bd�&��z�J�����A=�(Ns�X��U�Ѯ�X���T[D3��@�z�Q�q�[	�.Exr��@�IZx�L!gTpؠ)�'����٨ƭU�KO�y`��=�*���%ÛF�#�ҡ���Ɋ���,XXz@�1��f.8���1x[-G��:�ka{(�0�;f�J�V�@��{�Y�"����徫���\哄qqy@��D-R�%e�$�gnm�=B�xM��������"E��%�bB����Y�T�e.���}�������(��:@��f!�ƴ�а ��5�eD�$���Mp\8)�J����#�L��_�0�~�W͔�b���zhyC�	���m3��c���&�"�      �      x�uYIv�ȖW�0�D�у 6h�Ԅ�XiVʢ�3�sX�U�J�HJ����u����x���a��Q�;�r�SG�j���$�z��|z>���y��z|$�a�L8�������)wd��P�]�H�L'����K��!i�\1'Hx9>�A���������p&���'a΍�2ũ�RFr���.����*����J:'.�3�Q���pC�����tx�-<��M6��<���c���J㨞��m�b�T�ʑ�3�Mx$�x�3���(��^*T��^��d}|���||9���	��?�h05�44����z�-��,�l�@�T%�%cT1K�qM���u�m>�����_�_���Tk�H�v%Ӧon�i�2�:��LEk��<}�p�Q�	����C�y�$��>���j,�o��%s����*G�43̈́m�|g�\Jjŭ$�m��c$�6���P��g	*��
Ab��z�am��X�f²��YR�EJi(ɋ3�z�~h�����#��VN5��vB�K�8�QWn6)�2*�&�1Ǚ"a��G/O��ǯ����";�瘴bj)u��V�*���D��I�W���J��N[CV����3�='�	�|9��n���)�$���R�6��Դ�4Q8O�,���VJR���@qs���Ǒ4���̱��2j�\�9_>[�u�������t�-Y�X:j��dn�FW�	A�\2��X�q�K�ɚo��wvٮ3�C��&��pf�Υ���&��L�q�.��=�1���px��ϴB�Pu`�ձ�W���T��e'�LZJ���� �`p�/���?�������?�\a��RMZll��v2��67*c ?�qP��8E�*"O�=_�<D����}̯0��29�8WԤ��t	h�%��&蒹��j)��Ҹ��E�?^�qmAiD������ŃS��.��V�b���n7I�I�����Gk-6TFB3
�ŌMoD7?4�/�çq�)�3h�#-���r�;���H�cS�*j��Vη�u���o���y� �7:�Vi47b�	\bE��`=��##e;��j�D,t�Y`�lV����G��������jy9>�Z�x��tN���TVw-[���(�zM+���|ty����N����y��?��}Ҡ�,Y+�lɃ&��A�)=��`�ء;O_l��LA��O����#I����N���r�����:�;N�E��5˨�2�f-�JS;���ɆEV�)���&�f�N�'R]^�P(	�/��1U�X3�c�z�Y�Vm���*;L�6�]0#��$YB�����$Ͼ����d"�ft*��Q,�h��Z��81��l��ZԌg^kq���Q�g�A��.~���2��w��n�����[��)� �i�RZ��<��g�3 �f�v9����+�8\z�9٩������ ҖE�M�;c����W8+����o�e���
Z	���ؐ�bcʡ+0B����q��LA^dvh��d��d#~�fꟄ��O�!Xc~��[��4�T1�J�,r�B�Jr@��\#�#&��r��n>�"d��=y��T��)&�x�E�<-�'����������#j����fU4�#ZIW���\���@).���ܮ�~���}9���/�A�t*I�F�n�u�{�0nl�i�0��3Үb+=��<·;���z�`7F�Qv��լ�p���3w6�6�N��:\
s���j~-��{���L���A���m�u7J��&���q�,l2o����Uh���JE���o�v� o��lDQ�M?8ʘ�&f[�>�4�ӏ���������l�4����r:�
��-׸�4���U�������w2��D�O���|0�Uٔ��N�!��h������^.y���ʿ]����n$��XM_�<���XYQ��H��#޲��|P�fb�rP�b�i�(C�M�xw��H�B������\�j�di��F�&��k�縻��w��jD;�%^M�G���Iҩв��ee�Ϲ:��h��K�F��֛R1�1��gu?�w�k��p�S�Ɇn���6ϫġ4[{�݇F(cJk�H��Tz�y�������z>�c�1��°z&��^h�6�"U�.]Hż��X
���������рݧ��$/%�����^zB�)�΢^'�!��T��Mv@����po4	���<s���M��<WZ��#@�d^34�J��vK*O������)R�کY꙱Mb�<^y.���l{��"�	`��u��&nf����+�p���^�By��I��;7*/�;�"�u�#=�W+�\p���|�ry;����^9�X]���]�拼 �*'���I/������x�y�:�����������-���il�U�<}�˜����˕�W�����!�R�ϜY	K`a�h��CPe��|Xsf��_ʚ��R��`^[� �3�S�C�|���*p���������/���y;}�?��!(;2�#���{TI��sф�������dI�\���A�|��� z��3�bP���3�b8�ۉ�4㈬���#h	v"�W`���/Iw�y��
����׈Es�[�3�_:�����uR�2X�ź-�O��j?��x<�!��χ�Ⲋx�V��B�n^nC�Th*1j�@��O��H����B�Pv*�R�N�Md�m�����wP$@��A�7�,�e�0���?^�C���r>������@�֯.��z]�Y��&�kގ���	����	����@z�]M������|��#�FD(�S��u��^�Q�����]D�d���ym��q�R���7@��k�vBp��lȗJ�9��a�w!���P�"B�\Rp:�lQTP�ϋ�j��9�%#j�p���Jv\6;���#A��[PX2��֤̈�5�.�%���?�|6P�j `�G����Y����q��<�����j%s�؇�9-�){}���O<d||}�?��i��l�)��kg ��b������� |ā|�"�S�$2�(�R��T}���<����*"�����B@eʞ��6�q���Y���[e܀()g��2;z?[��Y���P��lk9]<�f+�Ĭ'�4ȗ"��ՊY��,��ވ����+��4_�:9\2���(we�y-�\w
u2�k#�DOf��S-Iu|{�|9�~=��]�2�z0�j�
.��.��¨����
�d.@���8��P����������/�0l��k����A!sj��V��γ�Ej�$l�Z�YՂ����hP���0q��g6�R�0Ŕ�Dl٢�IR{֕ �q2Jc��Jd=���%�����e��?����x���Z��'��U,LG犎Ͻ=v2�uZ9���)2�Fc�s|���P!%S�33�Ҫ+T�/�1<�V�D H
�-X��t�+�l��=��V�)���+ `k�y0���}�з4�@�6$\m��1�������v|!q�P8��@ʯ{X&�>I�yG����j��#���q���*"N�S>��� ���Zq��+�H\�OF�z��D��l�_uRv��n����A��w%8N���_�$��0����%��`��2Zĉ
:f�EF��� ��c>ˏ�:1ܟ���h]�vfk�-��L��CT�_a,�0��@~)!���_�����_�~|��5�0h�췤�cae�Ay���7f2UR�-�t������<s�����^ТS���L��zU�ތ�v9&�Xa����e��޼ht�����]�A�/�'���̮V&ig�)��b�P�F"����X4�����@�I݁���y�w��"����6�֑^����������Es4Ŀٵ���h������������w��Qbu��!?Q(��D����������^W!�}>)mdlx��dQ�ʹ�"��FI'
��@����q͇�<�����pZe`;@C�����L�1��l�҈x�m��`�p�L�����S�n�KAt�B$����y����]�VE�ѐ%Hf]R��{����/~UC��)�s!r���.�&���ߡ��ަ"�C
�n2lf�P���7�j. �  �iꪭao�9nh�U5���|��R��m�dZ��p�� �����xz~�����!ڟ�E�VH@n
����ugVm���p�D�4��(��X�u�(��e�a���XT�>g1�WYs��lf3��ҍ�v&B �}���MS�A�/���A׭���[��T�ekUnK�UQ�-�31C&F��u����+�b��=��ww?Ӛ+y$B��u��G�Q^t���?uk����z@L��������������O��$�����wj��	e��.���I���)3A�Ҋ���%m��`I}|}��j0>��]��+�Ԙ�s^9Q��z;�xL�������j�;W����O�KNϧ�������F��˹Yi9��V���L�k��A��*F�8���UCv���_�h����7���dEY7n-$�B�~�&-����d�s�<���_u���~1'ׯEN]Q�5����u���MLD �QM���M�X2����~�WuW��4�ź�.]�]ؖx��ƿA'q���Bd���hĈ������|����9*���冷W��[�w�j�taG�6o��������?�ϧ;����pwԯ�b�j��I�w�L�ƾ��2ƅi]/���[ߒ|��������%ng�߈.s��;�lR3ƣm��/���0�d���_3���1����<�J���\�\e[ѥu��hx���A:I !���]ʹ�/q�#�Zsy��������0n��)�}�?�u��l�p�C�V�R�Υ���.�!�Gl��_@v%@��O������b�
�-���r�xk�(��u�e��x�`@�a�@�|��&�<M��RO�e
'�D'9h22���Y���t�����b�zƸ�	��U���I%;��Tl���L!��ea��RF��bqF���?����>=�/�s�՘��KA;�-�y�ϴb>���L&�1��	      �   L  x��V�n�H|���?���/~�r�p	B�/>�,!��J������_���DgE�x�5�U]]=�A��B�J�6���)�		E�-�mZF�t�-7iT�oY�+�]V�~6O�Y1�2��,�"�������-*v�w|ey�Dy�����*�44]}Cf��"�0S�u��_���*�o���fY����s�O�e��مx��BK�Gt�l�/�hWD��F��*٥+�W�2A���Xs�BL@d���(/���	eW��HR���uLX��e�Eծ�n��Em�U
GdI^�z$���h͕ jf1WG����EU���f�6}5c��Ԧ�u�w�2��D����!��m���Śb	H��<�
�G�Q���U��+8am���|�溥$���|FY�T����AD�'�/�)���L�ml7	�I�����+L��B}�s��^�2m�����0(D��M�]Ex �
q�?|�oMW�S��7�c���N�-S�Ո����|5-�C��z����8�u�Fvj��\ m�h�jY�'�ʇ������m��B���TϾ�1]D,�GnIY ���l�.���Z�\cC쫐tČ4��gI*�'v}<�؅��Y�_�>t����&�[�����O�_�y2�Y��\@b���Yǌ�qعz�̫d����{�031���M	J3���M���(�S�7j+_#o���w�J��h�	)�=Ht��4�8��Kq��&��L�A�.P����������=d\��ʹA�M�1mc�_�3�1.?�]M����ڈK*��W�k�����)}��$	��B3WOd\�]G,Y���}2W]ƽ��z��k�e-ҧ%NQ���X^}�Ez�^��
�B'���z�;6W�<L)�#�~5l �m�_F�<���� �	i�g�����I ��Fg͌�����eD?���;j��C;X[�._jh���!@�ȓ���jWvg�!3����>f�>h�j!{��3�w��ﭳ��~5������4��7ރ|U7JyY�{y�o8��D��1��HbS`Ivu����X�_�n�SwϾ"��-�� �nT�     