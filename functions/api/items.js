/**
 * GET /api/items — public, read-only list of all tracked titles in story order.
 */
export async function onRequestGet(context) {
  const { env } = context;
  const { results } = await env.DB.prepare(
    'SELECT id, chronological_order, title, type, franchise, phase, era, watched, image_url FROM items ORDER BY chronological_order ASC'
  ).all();

  return Response.json(results, {
    headers: { 'Cache-Control': 'no-store' },
  });
}
