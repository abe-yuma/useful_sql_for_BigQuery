EXECUTE IMMEDIATE FORMAT
  (
    """
      SELECT
        *
      FROM
          A --Aのテーブルを持ち縦持ちにする(つまり、Aは横持のテーブルが想定される)
        UNPIVOT
          (
             column_value          --縦持ち時に値を入れたいカラム名称をcolumn_valueに入れる
             FOR column_name IN %s --横持ち時にまとめたカラム名を格納するカラムの名称をcolumn_nameに入れる
          ) pivot_table
      WHERE
        A.column_value IS NOT NULL
    """,
    (
      SELECT
        CONCAT("(",STRING_AGG(column_name,","),")")
      FROM
        (
          SELECT
            DISTINCT
              B.column_name --縦持ち時に、column_nameに格納するカラムの名称の一覧をB.column_nameに入れる
            FROM
              B
            WHERE
              B.column_name IS NOT NULL
            ORDER BY
              B.column_name
        )
    )
  )
