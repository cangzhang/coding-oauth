<script>
  import { onMount, onDestroy } from 'svelte';

  export let code;
  export let state;
  export let callbackUri;
  export let team;
  export let scope;
  export const clientId = `ff768664c96d04235b1cc4af1e3b37a8`;

  const didMount = () => {
    const { searchParams } = new URL(document.location);
    code = searchParams.get(`code`) || ``;
    state = searchParams.get(`state`) || ``;
    team = searchParams.get(`team`) || ``;
    scope = searchParams.get(`scope`) || ``;

    callbackUri = decodeURIComponent(searchParams.get(`callbackUri`) || ``);
    if (callbackUri) {
      localStorage.removeItem(`callbackUri`);
      localStorage.setItem(`callbackUri`, callbackUri);
    } else {
      callbackUri = localStorage.getItem(`callbackUri`);
    }

    if (code && state) {
      setTimeout(() => {
        window.open(`${callbackUri}&state={state}&code=${code}`, `_self`);
      }, 200);
    }
  };

  onMount(didMount);
  onDestroy(() => {
    if (typeof window !== 'undefined') {
      localStorage?.removeItem(`callbackUri`);
    }
  });
</script>

<style>
  main {
    text-align: center;
    padding: 1em;
    max-width: 240px;
    margin: 0 auto;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen-Sans, Ubuntu, Cantarell, 'Helvetica Neue',
      sans-serif;
  }

  h1 {
    color: #ff3e00;
    text-transform: uppercase;
    font-size: 4em;
    font-weight: 100;
  }

  @media (min-width: 640px) {
    main {
      max-width: none;
    }
  }
</style>

<svelte:head>
  <title>Connect to CODING</title>
</svelte:head>

<main>
  <h1>Connect</h1>
  <pre>code: {code}</pre>
  <pre>state: {state}</pre>
  <pre>callbackUri: {`${callbackUri}&state=${state}&code=${code}`}</pre>
  {#if !code}
    <a
      href="https://{team || `e`}.coding.net/oauth_authorize.html?client_id={clientId}&response_type=code&scope={scope}&state={state}&callbackUri={callbackUri}"
    >
      Authorize
    </a>
  {/if}
  {#if code}<button id="openVSCode"> <a href="{callbackUri}&state={state}&code={code}">Open VS Code</a> </button>{/if}
</main>
