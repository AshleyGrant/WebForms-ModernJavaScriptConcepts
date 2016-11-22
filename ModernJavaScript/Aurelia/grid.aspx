<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="grid.aspx.cs" Inherits="ModernJavaScript.Aurelia.grid" MasterPageFile="~/Site.Master" %>

<%@ Register Namespace="ModernJavaScript.Controls" TagPrefix="my" Assembly="ModernJavaScript" %>

<asp:Content runat="server" ContentPlaceHolderID="MainContent">

    <div data-ng-app="myContent">

        <h2>Aurelia Grid Sample</h2>

        <p>
            Our markup should be pretty standard to databind our grid. This simple grid is configured to load 3 customer
      records that are hardcoded into our code-behind and accessible through a GetCustomers method that was perfect for server-side model binding, but when a static keyword and a WebMethodAttribute are added, it now delivers data to the client.
   
       
        </p>

        <p>As a desired outcome of the translation, any data formatting that was defined in a bound column of a template column should be translated to appropriate JavaScript formatting using the Knockout template langauge.  At its simplest, a BoundColumn with no formatting should be translated like this:</p>

        <h4>Server-Side</h4>
        <code>&lt;asp:BoundField DataField="FirstName" HeaderText="First Name" /&gt; 
    </code>

        <p>
            As a principle, any server-side configuration that a developer expected on the control should be applied identically with the client-side framework.
   
       
        </p>

        <h4>Rendered HTML</h4>
        <code>&lt;th&gt;First Name&lt;/th&gt;<br />
            ...</br>
      &lt;td&gt;${customer.FirstName}&lt;/td&gt;
    </code>
        <br />
        <br />


<%--        <asp:LinkButton runat="server" ID="ToggleLink" OnClick="ToggleLink_Click">
      Get Data using <%: IsClientSideDataBindingEnabled ? "Server-Side" : "Client-Side" %> data binding
    </asp:LinkButton>--%>


        <%-- 
    
    PROPOSED CODE CHANGE
  
    Additional attribute supported:  @ClientDataBinding: bool  
      Activates Modern JavaScript Rendering and client-side databinding

    --%>
        <h3>Sample</h3>

        <my:AuGridView runat="server" ID="myGrid" ClientIDMode="Static" AutoGenerateColumns="false"
            ClientDataBinding="true" WebMethod="GetCustomers">
            <%-- 
      The proposed additional configuration property is configured on this grid and some code is present in the 
      code-behind to appropriately trigger the EmptyDataTemplate rendering, which contains the proposed
      output HTML in its simplest format.
      --%>
            <EmptyDataTemplate>
            </EmptyDataTemplate>
            <Columns>
                <asp:BoundField DataField="ID" HeaderText="ID" />
                <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                <asp:BoundField DataField="FirstOrderDate" HeaderText="First Order Date" DataFormatString="{0:d}" />
            </Columns>
        </my:AuGridView>

    </div>

</asp:Content>

<asp:Content runat="server" ContentPlaceHolderID="endOfPage">
    <script src="au-scripts/system.js"></script>
    <script src="au-scripts/config-esnext.js"></script>
    <script src="au-scripts/aurelia-core.js"></script>
    <script type="text/javascript">
        // Bootstrap Aurelia
        (function () {
            function FormatDate(dt) {
                return (dt.getMonth() + 1).toString() + "/" + (dt.getDate()).toString() + "/" + dt.getFullYear().toString();
            }

            Promise.all([System.import('aurelia-bootstrapper'),System.import('aurelia-framework')])
            .then(([bootstrapper, framework]) => {

                bootstrapper.bootstrap((aurelia) => {
                    aurelia.use
                    .basicConfiguration()
                    .developmentLogging();

                    configure(aurelia, framework);

                    aurelia.start().then(app => {
                        aurelia.enhance();
                    });
                });
            });
            

        })();

  </script>
</asp:Content>
