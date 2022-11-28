                                    -- SE CREA LA BASE DE DATOS
CREATE DATABASE desafio_oscar_acevedo_111;
CREATE DATABASE
\c desafio_oscar_acevedo_111
-- Ahora está conectado a la base de datos «desafio_oscar_acevedo_111» con el usuario «postgres».

1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
claves primarias, foráneas y tipos de datos. (1 punto)

                                    -- SE CREA LA PRIMERA TABLA
CREATE TABLE films(
id SERIAL PRIMARY KEY,
name VARCHAR (255),
year INT);
-- CREATE TABLE

                                    -- SE INSERTAN LOS DATOS DE LA PRIMERA TABLA

INSERT INTO films(name, year)
VALUES ('Scarie movie 3', 2003), ('La isla siniestra', 2010),
('El lobo de Wall Street', 2013), ('Hustle', 2022),
('Contratiempo', 2017);
-- INSERT 0 5

                                    -- SE CREA LA SEGUNDA TABLA

CREATE TABLE tags(
  id SERIAL PRIMARY KEY,
  tag VARCHAR (32));
-- CREATE TABLE

                                    -- SE INSERTAN LOS DATOS DE LA SEGUNDA TABLA

INSERT INTO tags (tag)
VALUES('Comedia de terror'), ('Thriller psicologico'),
('Comedia negra biografica'), ('Drama deportivo'),
('Suspenso');
-- INSERT 0 5

                                    
                                    -- SE CREA LA TABLA INTERMEDIA
                                    
CREATE TABLE films_tag(
  id SERIAL PRIMARY KEY,
  films_id INT,
  tag_id INT,
  FOREIGN KEY ("films_id")
  REFERENCES films(id),
  FOREIGN KEY ("tag_id")
  REFERENCES tags(id));
  -- CREATE TABLE

                                    -- SE INSERTAN LOS DATOS DE LA TABLA INTERMEDIA

2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
segunda película debe tener dos tags asociados. (1 punto)

INSERT INTO films_tag(films_id, tag_id)
VALUES (1,1), (1,2), (1,3), (2,1), (2,2);
-- INSERT 0 5

3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
mostrar 0. (1 punto)

-- OPCION 1
SELECT films.name, COUNT(films_tag.tag_id) FROM films 
LEFT JOIN films_tag ON films.id = films_tag.films_id GROUP BY films.name;

-- OPCION 2
SELECT films.name, COUNT(tags) FROM films 
LEFT JOIN films_tag ON films.id = films_tag.films_id
LEFT JOIN tags ON tags.id = films_tag.tag_id 
GROUP BY films.name;

            name          | count
  ------------------------+-------
  La isla siniestra      |     2
  Hustle                 |     0
  El lobo de Wall Street |     0
  Scarie movie 3         |     3
  Contratiempo           |     0
(5 filas)

  4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
datos. (1 punto)
                                    -- SE CREA LA PRIMERA TABLA

CREATE TABLE questions(
  id SERIAL PRIMARY KEY,
  question VARCHAR(255),
  correct_answer VARCHAR);
  -- CREATE TABLE

                                    -- SE CREA LA SEGUNDA TABLA
CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  age INT);
  -- CREATE TABLE

                                    -- SE CREA LA TABLA INTERMEDIA
CREATE TABLE answers(
  id SERIAL PRIMARY KEY,
  answer VARCHAR(255),
  user_id INT,
  question_id INT,
  FOREIGN KEY ("user_id") REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY ("question_id") REFERENCES questions(id));
  -- CREATE TABLE
  
5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
(1 punto)
a. Contestada correctamente significa que la respuesta indicada en la tabla
respuestas es exactamente igual al texto indicado en la tabla de preguntas.

INSERT INTO questions (question, correct_answer)
VALUES ('¿Que raza es Goku?', 'Saiyajin'),('¿Quien es el principe de los Saiyajin?', 'Vegeta'),
('¿Quien es el Legendario Super Saiyajin?', 'Broly'), ('¿Quien es el villano que despierta Babidi?', 'Majin Boo'),
('¿Que transformación provoca la unión de dos seres?', 'La Fusión');
-- INSERT 0 5

INSERT INTO users(name, age)
VALUES ('Oscar', 31), ('Seba', 41), ('Valeria', 27), 
('Juan', 43), ('Yarenla', 30);
-- INSERT 0 5

INSERT INTO answers (answer, question_id, user_id)
VALUES ('Saiyajin', 1, 1), ('Saiyajin', 1, 2), 
('Vegeta', 2, 3), ('Mr Satan', 3, 4), 
('Cell', 4, 5);
-- INSERT 0 5

6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
pregunta). (1 punto)

SELECT users.name, COUNT (answers.answer) AS correct_answer FROM questions 
INNER JOIN answers ON questions.id = answers.question_id 
INNER JOIN users ON answers.user_id = users.id
WHERE questions.correct_answer = answers.answer GROUP BY users.name;

7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
respuesta correcta. (1 punto)

-- OPCION 1

SELECT questions.question, COUNT (users.id) AS users FROM users 
INNER JOIN answers ON users.id = answers.user_id 
INNER JOIN questions ON answers.question_id = questions.id 
WHERE questions.correct_answer = answers.answer 
GROUP By questions.question;

-- OPCION 2

SELECT questions.question, COUNT(users.id) FROM questions
LEFT JOIN answers ON answers.answer = questions.correct_answer
LEFT JOIN users ON answers.user_id = users.id
GROUP BY questions.question;

8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
primer usuario para probar la implementación. (1 punto)

CREATE TABLE answers(
  id SERIAL PRIMARY KEY,
  answer VARCHAR(255),
  user_id INT,
  question_id INT,
  FOREIGN KEY ("user_id") REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY ("question_id") REFERENCES questions(id));
  DELETE FROM users WHERE id = 1;

9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
datos. (1 punto)

ALTER TABLE users ADD CHECK (age > 18);

10. Altera la tabla existente de usuarios agregando el campo email con la restricción de
único. (1 punto)

ALTER TABLE users ADD COLUMN email VARCHAR UNIQUE;