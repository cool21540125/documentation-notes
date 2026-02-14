// Neo4j - intermediate nodes
//

// -------------------------------- Before --------------------------------
//
// (Person)                                          (Company)
// +--------------+           WORKS_AT               +---------------+
// | name: 'Tony' |--------------------------------->| name: 'Weiby' |
// | dob: '1987'  |  dates: ['2018...', '2019...']   |               |
// +--------------+  roles: ['Engineer', 'Senior']   +---------------+
//
// ------------------------------------------------------------------------

// -------------------------------- After ---------------------------------
// 
// (Role: Software Engineer)
//                                     +-------------------------+
//                                     | name: 'Software Engineer'|
//                                     +------------^------------+
//                                                  |
//                 (Employment)                  IN_ROLE
//                +-----------------+               |
//           +--->| from: 2018-07-18|---------------+
//           |    | to:   2019-10-15|               |
//           |    +-----------------+           AT_COMPANY
//           |                                      |
//        WORKED                                    v
//           |                               (Company: Weiby)
//  (Person) |                               +-------------------+
// +---------+----+                          | city: 'Malmo'     |
// | name: 'Tony' |                          | country: 'Sweden' |
// +---------+----+                          +---------^---------+
//           |                                         |
//        WORKED                                   AT_COMPANY
//           |                                         |
//           |     (Employment)                        |
//           +--->+-----------------+                  |
//                | from: 2019-10-16|------------------+
//                | to:   'present' |
//                +--------+--------+
//                         |
//                      IN_ROLE
//                         |
//                         v
//                   +------------+
//                   | name: 'SRE'|
//                   +------------+
//                    (Role: SRE)
// 
// ------------------------------------------------------------------------

// 1. 找到舊的關係
MATCH (p:Person {name: 'Tony'})-[r:WORKS_AT]->(c:Company)

// 2. 針對關係中的每個屬性索引進行展開
WITH p, r, c
UNWIND range(0, size(r.dates) - 1) AS idx

// 3. 建立新的結構
MERGE (role:Role {name: r.roles[idx]})
CREATE (p)-[:WORKED]->(e:Employment {
    from: split(r.dates[idx], ' - ')[0],
    to: split(r.dates[idx], ' - ')[1]
})
CREATE (e)-[:IN_ROLE]->(role)
CREATE (e)-[:AT_COMPANY]->(c)

// 4. (選填) 刪除舊的關係
// DELETE r