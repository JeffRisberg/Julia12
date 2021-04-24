module Articles

export Article, save, find

using ...Database, MySQL, JSON, Tables

struct Article
  content::String
  links::Vector{String}
  title::String
  image::String
  url::String

  Article(; content = "", links = String[], title = "", image = "", url = "") = new(content, links, title, image, url)
  Article(content, links, title, image, url) = new(content, links, title, image, url)
end

function find(url) :: Vector{Article}
  articles = Article[]

  result = DBInterface.execute(CONN, "SELECT content, links, title, image, url FROM `articles` WHERE url = '$url'")

  for row in Tables.rows(result)
    push!(articles, Article(Tables.getcolumn(row, 1),
                            JSON.parse(Tables.getcolumn(row, 2)),
                            Tables.getcolumn(row, 3),
                            Tables.getcolumn(row, 4),
                            Tables.getcolumn(row, 5)))
  end

  articles
end

function save(a::Article)
  sql = "INSERT IGNORE INTO articles
            (title, content, links, image, url) VALUES (?, ?, ?, ?, ?)"
  stmt = DBInterface.prepare(CONN, sql)
  result = DBInterface.execute(stmt,
                          [ a.title,
                            a.content,
                            JSON.json(a.links),
                            a.image,
                            a.url]
                        )
end

function createtable()
  sql = """
    CREATE TABLE `articles` (
      `title` varchar(1000),
      `content` text,
      `links` text,
      `image` varchar(500),
      `url` varchar(500),
      UNIQUE KEY `url` (`url`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8
  """

  DBInterface.execute(CONN, sql)
end

end
