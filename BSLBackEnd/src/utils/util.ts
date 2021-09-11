export function buildQuery(body: any): string {
  let query = `SELECT it.itinerary_id AS itinerary_id, 
                      (it.info::JSON->>'name')::VARCHAR AS name 
                      FROM itinerary.itinerary AS it`;
  let and = undefined;
  let where = undefined;
  if (body.category) {
    query += ` JOIN itinerary.itinerary_category_inter itc 
              ON itc.itinerary_id = it.itinerary_id AND itc.itinerary_category_id = $3`;
  }
  if (body.role === 0) {
    where = " WHERE ";
    query += ` JOIN itinerary.user_itinerary uit ON uit.itinerary_id = it.itinerary_id`;
    query += where + "uit.user_id = $6";
  }
  if (body.duration) {
    if (where) {
      and = " AND ";
      query += and + "(it.info::JSON ->> 'duration')::INTEGER = $1";
    } else {
      where = " WHERE ";
      query += where + "(it.info::JSON ->> 'duration')::INTEGER = $1";
    }
  }
  if (body.totalPrice) {
    if (where) {
      and = " AND ";
      query += and + "(it.info::JSON ->> 'total_price')::NUMERIC = $2";
    } else {
      where = " WHERE ";
      query += where + "(it.info::JSON ->> 'total_price')::NUMERIC = $2";
    }
  }
  if (body.groupType) {
    if (where) {
      and = " AND ";
      query += and + "it.group_type_id = $4";
    } else {
      where = " WHERE ";
      query += where + "it.group_type_id = $4";
    }
  }
  return query;
}
