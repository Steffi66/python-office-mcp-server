// Optional interoperability check; Bun and the SDK are not runtime dependencies.
// MCP_SDK_ROOT points to an installed @modelcontextprotocol/sdk directory.
import { pathToFileURL } from 'node:url';
const root = process.env.MCP_SDK_ROOT;
const url = process.env.MCP_URL;
if (!root || !url) throw new Error('MCP_SDK_ROOT and MCP_URL are required');
const { Client } = await import(pathToFileURL(`${root}/dist/esm/client/index.js`).href);
const { StreamableHTTPClientTransport } = await import(pathToFileURL(`${root}/dist/esm/client/streamableHttp.js`).href);
const token = process.env.OFFICE_MCP_HTTP_TOKEN;
const transport = new StreamableHTTPClientTransport(new URL(url), {
  requestInit: token ? {headers: {Authorization: `Bearer ${token}`}} : undefined,
});
const client = new Client({name: 'office-sdk-smoke', version: '1'}, {capabilities: {}});
try {
  await client.connect(transport);
  const tools = await client.listTools();
  if (!tools.tools.some((t: any) => t.name === 'office_patch')) throw new Error('office_patch missing');
  const result = await client.callTool({name: 'office_help', arguments: {}});
  if (result.isError || result.structuredContent?.success !== true) throw new Error('Invalid help result');
  const resources = await client.listResources();
  if (!resources.resources.some((r: any) => r.uri === 'office://guidance/workflows')) throw new Error('Guidance resource missing');
  await client.readResource({uri: 'office://guidance/workflows'});
  const prompts = await client.listPrompts();
  if (!prompts.prompts.some((p: any) => p.name === 'review_document')) throw new Error('Review prompt missing');
  await client.getPrompt({name: 'review_document', arguments: {file_path: 'synthetic.docx', document_type: 'word'}});
  console.log(JSON.stringify({passed: true, tools: tools.tools.length, resources: resources.resources.length,
    prompts: prompts.prompts.length, session: Boolean(transport.sessionId)}));
  await transport.terminateSession();
} finally {
  await client.close();
}
