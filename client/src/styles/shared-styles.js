/**
 * @license
 * Copyright (c) 2016 The Polymer Project Authors. All rights reserved.
 * This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
 * The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
 * The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
 * Code distributed by Google as part of the polymer project is also
 * subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
 */

import '@polymer/polymer/polymer-element.js';
import '@vaadin/vaadin-lumo-styles/style.js';
import '@vaadin/vaadin-lumo-styles/color.js';
import '@vaadin/vaadin-lumo-styles/sizing.js';
import '@vaadin/vaadin-lumo-styles/typography.js'
import '@vaadin/vaadin-lumo-styles/icons.js'

import { html } from '@polymer/lit-element';

export const sharedStyles = html`
    <style include="lumo-color lumo-typography">

      .card {
        margin: var(--lumo-space-m);
        padding: var(--lumo-space-m);
        border-radius: var(--lumo-border-radius);
        background-color: var(--lumo-base-color);
        box-shadow: var(--lumo-box-shadow-s);
      }

      .circle {
        display: inline-block;
        width: 64px;
        height: 64px;
        text-align: center;
        color: #555;
        border-radius: 50%;
        background: #ddd;
        font-size: 30px;
        line-height: 64px;
      }

      h1 {
        margin: 16px 0;
        color: #212121;
        font-size: 22px;
      }
    </style>`;
  
