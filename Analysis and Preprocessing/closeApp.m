function closeApp(app, fields)

global fields

clear global fields
%fprintf('Fields deleted\n')
delete(app)

end