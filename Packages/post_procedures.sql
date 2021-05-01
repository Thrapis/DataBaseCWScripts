
CREATE OR REPLACE PACKAGE Post_Package IS
	PROCEDURE InsertPost(par_post_name in nvarchar2, par_category in nvarchar2, inserted out int);
	PROCEDURE UpdatePost(par_id in int, par_post_name in nvarchar2, par_category in nvarchar2, updated out int);
    PROCEDURE DeletePost(par_id in int, deleted out int);
	PROCEDURE GetPostById(par_id in int, post_cur out sys_refcursor);
	PROCEDURE GetAllPosts(post_cur out sys_refcursor);
END Post_Package;



CREATE OR REPLACE PACKAGE BODY Post_Package IS

    PROCEDURE InsertPost(par_post_name in nvarchar2, par_category in nvarchar2, inserted out int) IS
        LikeInsertion int;
    BEGIN
        SELECT COUNT(*) INTO LikeInsertion FROM POST WHERE POST_NAME = par_post_name;
        IF LikeInsertion = 0 THEN
            INSERT INTO POST (POST_NAME, CATEGORY) VALUES (par_post_name, par_category)
            RETURNING ID INTO inserted;
        ELSE
            inserted := -1;
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            inserted := -1;
            ROLLBACK;
    END;

    PROCEDURE UpdatePost(par_id in int, par_post_name in nvarchar2, par_category in nvarchar2, updated out int) IS
    BEGIN
        UPDATE POST set POST_NAME = par_post_name, CATEGORY = par_category WHERE ID = par_id
        RETURNING ID INTO updated;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            updated := -1;
            ROLLBACK;
    END;

    PROCEDURE DeletePost(par_id in int, deleted out int) IS
    BEGIN
        DELETE POST WHERE ID = par_id RETURNING ID INTO deleted;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            deleted := -1;
            ROLLBACK;
    END;

    PROCEDURE GetPostById(par_id in int, post_cur out sys_refcursor) IS
    BEGIN
        OPEN post_cur FOR SELECT * FROM POST WHERE ID = par_id;
    END;

    PROCEDURE GetAllPosts(post_cur out sys_refcursor) IS
    BEGIN
        OPEN post_cur FOR SELECT * FROM POST;
    END;

END Post_Package;