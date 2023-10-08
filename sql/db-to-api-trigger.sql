-- Prereq
--sp_configure 'show advanced option', 1
--Reconfigure;
--sp_configure 'Ole Automation Procedures', 1;
--reconfigure;


CREATE OR ALTER TRIGGER tg_after_insert ON database.dbo.table
 AFTER INSERT
 AS
 BEGIN 
  Declare
  @obj int, @hr int, @responseText nvarchar(2000),
  @statusText nvarchar(32), @status nvarchar(32),
  @postData nvarchar(2000);

  select @postData = concat('title=',i.title,'&description=',
  i.description, '&price=', i.price)
  from inserted i;

  DECLARE @sUrl varchar(200) = 'http://192.168.1.249:8000/api/add';

  exec @hr = sp_OACreate 'MSXML2.ServerXMLHttp', @obj OUT
   --if @hr <> 0 RAISERROR ('Error message.', 10, 1)


  exec @hr = sp_OAMethod @obj, 'open', NULL, 'POST', @sUrl, false
  -- if @hr <> 0 RAISERROR ('Error message.', 10, 1)

  exec @hr = sp_OAMethod @obj, 'setRequestHeader', NULL, 'Content-Type',
  'application/x-www-form-urlencoded'
   --if @hr <> 0 RAISERROR ('Error message.', 10, 1)

  exec @hr = sp_OAMethod @obj, send, NULL, @postData
   --if @hr <> 0 RAISERROR ('Error message.', 10, 1)

  exec @hr = sp_OAGetProperty @obj, 'status', @status OUT;
  exec @hr = sp_OAGetProperty @obj, 'statusText', @statusText OUT;
  exec @hr = sp_OAGetProperty @obj, 'responseText', @responseText OUT;

  print 'Statut:'+ @status +'('+ @statusText+')';
  print 'Response:'+ '('+ @responseText+')';

  exec @hr = sp_OADestroy @obj
END;
