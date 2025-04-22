from flask import Flask, render_template, request, jsonify
import mariadb

app = Flask(__name__)

# Set up MariaDB connection
def get_db_connection():
    conn = mariadb.connect(
        host='maraigremlin.cvwyoskgmxtl.ap-southeast-2.rds.amazonaws.com',
        port =3306,
        user='admin',
        password='Gremlin1212',
        database='todo'
    )
    return conn

@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT id, description, completed FROM tasks")
    tasks = [{'id': id, 'description': desc, 'completed': bool(comp)} for id, desc, comp in cursor]
    conn.close()
    return render_template('index.html', tasks=tasks)

@app.route('/tasks', methods=['POST'])
def add_task():
    data = request.get_json()
    description = data.get('description', '')
    if not description:
        return jsonify({'error': 'Description is required'}), 400

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("INSERT INTO tasks (description) VALUES (?)", (description,))
    conn.commit()
    task_id = cursor.lastrowid
    conn.close()
    return jsonify({'id': task_id, 'description': description, 'completed': False}), 201

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)

