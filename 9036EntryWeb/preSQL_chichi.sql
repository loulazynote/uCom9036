truncate table totalsortable;
truncate table galeshapley;

delete from ManSortable where MId=117;
delete from WomanSortable where WId=119;

UPDATE SignUp  SET name=N'周星星' where Id=117;
--select pwd,name,height,birth,hobby,email  from SignUp where Id=117;
