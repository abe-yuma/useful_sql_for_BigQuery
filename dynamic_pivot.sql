EXECUTE IMMEDIATE FORMAT
  (
    """
      SELECT
        *
      FROM
          A --Aのテーブルを対象に横持にする。つまり、Aのテーブルは縦持ちのテーブルとなる。
        PIVOT
          (
             SUM(A.column_value) --横持ちにしたい各種カラムに入れたい値が入っているカラムをcolumn_valueに入れる
             FOR A.column_name IN %s --横持ちにしたい各種カラム名が入っているカラムをcolumn_nameに入れる
          ) pivot_table
    """,
    (
      SELECT
        CONCAT("(",STRING_AGG(column_name,","),")")
      FROM
        (
          SELECT
            DISTINCT
              B.column_name --横持ち後の各種カラム名が入っているカラムをcolumn_nameに入れる。テーブルAとBは一致してもよい。むしろ一致推奨。
            FROM
              B
            WHERE
              B.column_name IS NOT NULL
            ORDER BY
              B.column_name
        )
    )
  )
