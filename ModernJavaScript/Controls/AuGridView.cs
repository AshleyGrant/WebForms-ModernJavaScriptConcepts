using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ModernJavaScript.Controls
{
    public class AuGridView : GridView
    {
        [Bindable(true)]
        public string WebMethod { get; set; }

        [Bindable(true)]
        public bool ClientDataBinding { get; set; }
        protected override void Render(HtmlTextWriter writer)
        {
            var clientID = this.ClientID.ToLowerInvariant();

            if (this.ClientDataBinding)
            {
                writer.WriteFullBeginTag(clientID);
                writer.Write(writer.NewLine);
                writer.WriteFullBeginTag("script");
                writer.Write(writer.NewLine);

                writer.WriteLine("function configure(aurelia, framework) {");
                writer.WriteLine($"  const inlineView = framework.inlineView; ");
                writer.WriteLine($"  var {clientID} = function() {{");
                writer.WriteLine($"    function {clientID}() {{");
                writer.WriteLine($"      this.headers = [");
                foreach(BoundField column in this.Columns)
                {
                    writer.WriteLine($"  '{column.HeaderText}',");
                }
                writer.WriteLine($"      ];");
                writer.WriteLine($"    }}");
                writer.WriteLine();
                writer.WriteLine($"    {clientID}.prototype.bind = function() {{");
                writer.WriteLine($"      var _self = this;");
                writer.WriteLine($"      return new Promise(function(resolve) {{");
                writer.WriteLine($"        PageMethods.{this.WebMethod}(resolve);");
                writer.WriteLine($"      }}).then(function(data) {{");
                writer.WriteLine($"        _self.data = data;");
                writer.WriteLine(@"      });");
                writer.WriteLine(@"    }");
                writer.WriteLine();
                writer.WriteLine($"   return {clientID};");
                writer.WriteLine($"  }}();");

                writer.Write("  inlineView('" +
                                 "<template>" +
                                 "<table>" +
                                 "  <tr>" +
                                @"   <th repeat.for=""header of headers"">" +
                                 "     ${header}" +
                                 "   </th>" +
                                 "  </tr>" +
                                 "  <tr repeat.for=\"row of data\">");

                foreach(BoundField column in this.Columns)
                {
                    writer.Write("<td>${row.");
                    writer.Write($"{column.DataField}");
                    writer.Write("}</td>");
                }
                                 
                 writer.Write(  "  </tr>" +
                                $"</table>" +
                                $"</template')({clientID});");

                writer.WriteLine($"  System.set('{clientID}', System.newModule({{ '{clientID}': {clientID} }}));");
                writer.WriteLine($"  aurelia.use.globalResources('{clientID}');");

                writer.WriteLine("}");
                writer.WriteEndTag("script");
            }
            base.Render(writer);

            if (this.ClientDataBinding)
            {
                writer.WriteEndTag(clientID);
            }
        }
    }
}


                //<table id = "myGrid" >
                //    < thead >
                //        < tr >
                //            < th > ID </ th >
                //            < th > First Name</th>
                //            <th>Last Name</th>
                //            <th>First Order Date</th>
                //        </tr>
                //    </thead>
                //    <tbody repeat.for="customer of Customers">
                //        <tr>
                //            <td>${ customer.ID}</td>
                //            <td>${customer.FirstName}</td>
                //            <td>${customer.LastName}</td>
                //            <td>${FormatDate(customer.FirstOrderDate)}</td>
                //        </tr>
                //    </tbody>
                //</table>