CREATE TRIGGER update_updated_at_trigger
BEFORE UPDATE ON memos
FOR EACH ROW
EXECUTE PROCEDURE update_updated_at();
